import json
import os
import cloudinary
import openai
import requests
import io
from cloudinary.uploader import upload
import base64
from core.errors.exceptions import ServerException

CAPI_KEY=os.getenv("CLD_API_KEY")
CAPI_SECRET=os.getenv("CLD_API_SECRET")
CGET_IMAGE_KEY = os.getenv("GET_IMAGE_KEY")
openai.api_key = os.getenv("OPENAI_API_KEY")
asticaAPI_key = os.getenv("ASTICA_API_KEY")
CGET_3D_KEY = os.getenv("GET_3D_KEY")

cloudinary.config( 
    cloud_name = "dtghsmx0s", api_key = CAPI_KEY, api_secret = CAPI_SECRET)

class AiGeneration:
    
    def __init__(self, request, upload) -> None:
        self.request = request
        self.upload = upload
        
    async def get_image(self, url, headers, data):
        headers['Authorization'] = 'Bearer ' + CGET_IMAGE_KEY
        response = requests.post(url, headers=headers, json=data)
        print(response.status_code, "THIS IS THE RESPONSE")
        if response.status_code != 200:
            print(response.json())
            raise ServerException('Error getting image 1')
        imageText = response.json()['image']

        if imageText is None or imageText == '' or imageText == 'null':
            raise ServerException('Error getting image 2')
        
        image = base64.b64decode(imageText)
        upload_result = upload(image)
        if not upload_result:
            raise ServerException('Error uploading image 3')
        return upload_result['url']
    
    async def create_from_text(self, data):        
        response =  openai.Image.create(
            prompt=data['prompt'],
            size="1024x1024",
            n=1
        )
        image_url = response["data"][0]["url"]
        image_data = requests.get(image_url).content
        upload_result = upload(image_data)
        if upload_result is None:
            raise ServerException('Error uploading image')
        return upload_result["url"]
    
    
    async def create_from_image(self, data):
        mask_data = base64.b64decode(data['mask'])
        image_data = base64.b64decode(data['image'])

        maskImage = io.BytesIO(mask_data).read()
        image = io.BytesIO(image_data).read()

        response = openai.Image.create_edit(
            image=image,
            mask=maskImage,
            prompt=data['prompt'],
            n=1,
            size="1024x1024"
        )
        image_url = response['data'][0]['url']
        image_data = requests.get(image_url).content
        upload_result = upload(image_data)
        if upload_result is None:
            return ServerException('Error uploading image')
        return upload_result["url"]


    async def image_variant(self, data):
        image_data = base64.b64decode(data['image'])
        response = openai.Image.create_variation(
            image=io.BytesIO(image_data).read(),
            n=1,
            size="1024x1024"
        )
        image_url = response['data'][0]['url']
        image_data = requests.get(image_url).content
        upload_result = upload(image_data)
        if upload_result is None:
            raise ServerException('Error uploading image')
        return upload_result["url"]

    
    async def upload_image(self, stringImage):
        image_data = base64.b64decode(stringImage)
        image  = io.BytesIO(image_data).read()
        upload_result = upload(image)
        if upload_result is None:
            raise ServerException('Error uploading image')
        return upload_result["url"]
    
    
    async def chatbot(self, data):
        messages = [
            {"role": "system", "content": "You're a kind helpful assistant, only respond with knowledge you know for sure, don't hallucinate information."},
            {"role": "user", "content": data['prompt']},
        ]
        try:
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=messages
                )
            return response.choices[0].message['content']
        except Exception as pr:
            raise ServerException('Error getting chatbot response')
    
    async def analysis(self, data):
        asticaAPI_payload = {
            'tkn': asticaAPI_key,
            'modelVersion': '2.1_full',
            'visionParams': 'gpt,describe',
            "gpt_prompt": data['prompt'],
            "gpt_length": '150',
            'input': data['image'],
        }
        response = requests.post(
            'https://vision.astica.ai/describe', 
            data=json.dumps(asticaAPI_payload),
            headers={ 'Content-Type': 'application/json', },
            timeout=60)
        if 'status' in response:
            if response['status'] == 'error':
                return ServerException('Error getting analysis')
            elif response['status'] == 'success':
                if "caption_GPTS" in response and 'caption' in response:
                    return {
                        'detail': response['caption_GPTS'],
                        'title': response['caption']['text']
                    }             
            raise ServerException('Error getting analysis')
    
    async def image_to_threeD(self, chat_id, id, data): 
        image_data = base64.b64decode(data['image'])
        image  = io.BytesIO(image_data).read()
        payload = json.dumps({
            "key": CGET_3D_KEY,
            "image": image, 
            "guidance_scale":5,
            "steps":64,
            "frame_size":256,
            "webhook": f"https://the-architect.onrender.com/chats{chat_id}/notify/{id}",
            "track_id": id
        })
        response = requests.post(
            'https://stablediffusionapi.com/api/v3/img_to_3d', 
            data=payload,
            headers={ 'Content-Type': 'application/json', },
            timeout=60
        )
        if response.status_code != 200:
            raise ServerException('Error getting 3D')
        response = response.json()
        return {
            'status': response['status'],
            "fetch_result": response['fetch_result']
        }
        
    async def text_to_threeD(self, chat_id, id, data):
        payload = json.dumps({
            "key": CGET_3D_KEY,
            "prompt": data['prompt'],
            "guidance_scale":20,
            "steps":64,
            "frame_size":256,
            "output_type":"gif",
            "webhook": f"https://the-architect.onrender.com/chats{chat_id}/notify/{id}",
            "track_id": id
        })
        response = requests.post(
            'https://stablediffusionapi.com/api/v3/txt_to_3d', 
            data=payload,
            headers={ 'Content-Type': 'application/json' },
            timeout=60
        )
        if response.status_code != 200:
            raise ServerException('Error getting 3D')
        response = response.json()
        return {
            'status': response['status'],
            "fetch_result": response['fetch_result'],
        }

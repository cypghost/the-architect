from core.use_cases.use_case import UseCase
from app.domain.repositories.post import BaseRepository
from core.common.equatable import Equatable
from core.common.either import Either
from core.errors.failure import Failure
from app.domain.entities.post import Post

class Params(Equatable):
    def __init__(self, post_id: str) -> None:
        self.post_id = post_id
        
class ViewPost(UseCase[Post]):
    def __init__(self, repository: BaseRepository):
        self.repository = repository
    
    async def __call__(self, params: Params) -> Either[Failure, Post]:
        return await self.repository.view_post(params.post_id)
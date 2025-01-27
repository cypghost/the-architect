from abc import ABC, abstractmethod
from typing import List
from app.domain.repositories import ContextManagerRepository
from core.common.either import Either
from core.errors.failure import Failure
from app.domain.entities.chat import Chat, ChatEntity, Notify


class BaseWriteOnlyRepository(ContextManagerRepository):
    @abstractmethod
    async def create_chat(self, chat: Chat) -> Either[Failure, ChatEntity]:
        ...
        
    @abstractmethod
    async def delete_chat(self, chat_id: str) -> Either[Failure, ChatEntity]:
        ...
        
    @abstractmethod
    async def notify (self, chat_id: str, notify_id: str, notify: Notify) -> Either[Failure, ChatEntity]:
        ...

class BaseReadOnlyRepository(ABC):
    @abstractmethod
    async def view_chats(self, user_id) -> Either[Failure, List[ChatEntity]]:
        ...

    @abstractmethod
    async def view_chat(self, chat_id: str) -> Either[Failure, ChatEntity]:
        ...

class BaseRepository(BaseReadOnlyRepository, BaseWriteOnlyRepository, ABC):
    ...

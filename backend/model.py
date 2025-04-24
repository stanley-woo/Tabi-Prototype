from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel


# ─────────────────────────────────────────────────────────────
# SQLModel Tables
# ─────────────────────────────────────────────────────────────


class User(SQLModel, table=True):
    user_id: Optional[int] = Field(default=None, primary_key=True)
    username: str

    itineraries: List["Itinerary"] = Relationship(back_populates="creator")


class Itinerary(SQLModel, table=True):
    itinerary_id: Optional[int] = Field(default=None, primary_key=True)

    title: str
    destination: str
    duration: str  # Format: "5D4N"

    created_at: datetime = Field(default_factory=datetime.utcnow)

    user_id: int = Field(foreign_key="user.user_id")

    creator: Optional[User] = Relationship(back_populates="itineraries")
    blocks: List["ItineraryBlock"] = Relationship(back_populates="itinerary")


class ItineraryBlock(SQLModel, table=True):
    block_id: Optional[int] = Field(default=None, primary_key=True)

    itinerary_id: int = Field(foreign_key="itinerary.itinerary_id")

    type: str  # 'text', 'image', 'map'
    content: str

    itinerary: Optional[Itinerary] = Relationship(back_populates="blocks")


# ─────────────────────────────────────────────────────────────
# Pydantic Schemas for API I/O
# ─────────────────────────────────────────────────────────────


class UserCreate(BaseModel):
    username: str


class UserRead(BaseModel):
    user_id: int
    username: str

    class Config:
        orm_mode = True


class ItineraryCreate(BaseModel):
    title: str
    destination: str
    duration: str
    user_id: int  # Match the DB field name for clarity


class ItineraryRead(BaseModel):
    itinerary_id: int
    title: str
    destination: str
    duration: str
    created_at: datetime

    user_id: int = Field(..., alias="creator_id")  # Optional alias for frontend naming
    creator: UserRead

    blocks: List["ItineraryBlockRead"] = []

    class Config:
        orm_mode = True
        allow_population_by_field_name = (
            True  # So you can use either `creator_id` or `user_id`
        )


class ItineraryBlockCreate(BaseModel):
    type: str
    content: str


class ItineraryBlockRead(BaseModel):
    block_id: int
    itinerary_id: int
    type: str
    content: str

    class Config:
        orm_mode = True


# ─────────────────────────────────────────────────────────────
# Static Data Model for Flutter (non-DB)
# ─────────────────────────────────────────────────────────────


class ItineraryStatic(BaseModel):
    id: int
    title: str
    destination: str
    days: int
    user_name: str

    image_url: str
    likes: int
    forks: int
    saves: int
    photo_urls: List[str] = []
    video_urls: List[str] = []

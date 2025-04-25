from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlmodel import Session, select
from sqlalchemy.orm import selectinload
from model import User, Itinerary, ItineraryBlock, UserRead, UserCreate, ItineraryCreate, ItineraryRead, ItineraryBlockCreate, ItineraryBlockRead, ItineraryStatic
from database import get_session, init_db
from fastapi.staticfiles import StaticFiles

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change this in prod: important since I don't want any websites on the net to access this backend.
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Run this when FastAPI boots up
@app.on_event("startup")
def on_startup():
    init_db()

# --------------------------
# USERS
# --------------------------


@app.post("/users", response_model=UserRead)
def create_user(user: UserCreate, session: Session = Depends(get_session)):
    # Need to check if user already exists by username
    existing_user = session.exec(select(User).where(user.username == User.username)).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Username is already taken")
    db_user = User(**user.dict())
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    return db_user


@app.get("/users", response_model=list[UserRead])
def list_users(session: Session = Depends(get_session)):
    return session.exec(select(User)).all()


# --------------------------
# ITINERARIES
# --------------------------


@app.post("/itineraries", response_model=ItineraryRead)
def create_itinerary(
    itinerary: ItineraryCreate, session: Session = Depends(get_session)
):
    db_itinerary = Itinerary(**itinerary.dict())
    session.add(db_itinerary)
    session.commit()
    session.refresh(db_itinerary)
    return db_itinerary


from typing import Optional


@app.get("/itineraries", response_model=list[ItineraryRead])
def list_itineraries(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, le=100),
    creator_id: Optional[int] = None,
    destination: Optional[str] = None,
    session: Session = Depends(get_session),
):
    print(f"Destination: {destination}")
    query = select(Itinerary).options(
            selectinload(Itinerary.blocks),
            selectinload(Itinerary.creator),
        )
    
    if creator_id is not None:
        query = query.where(Itinerary.user_id == creator_id)

    if destination is not None:
        query = query.where(Itinerary.destination == destination)

    query = query.offset(skip).limit(limit)
    try:
        results = session.exec(query).all()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")

    return results
    

    # Pagination


# @app.get("/itineraries/", response_model=list[ItineraryRead])
# def get_user_itineraries(user_id: int, session: Session = Depends(get_session)):
#     query = select(Itinerary).where(Itinerary.creator_id == user_id).options(selectinload(Itinerary.blocks), selectinload(Itinerary.creator))
#     return session.exec(query).all()

# --------------------------
# BLOCKS
# --------------------------


@app.post("/itineraries/{itinerary_id}/blocks", response_model=ItineraryBlockRead)
def add_block(
    itinerary_id: int,
    block: ItineraryBlockCreate,
    session: Session = Depends(get_session),
):
    db_block = ItineraryBlock(itinerary_id=itinerary_id, **block.dict())
    session.add(db_block)
    session.commit()
    session.refresh(db_block)
    return db_block


@app.get("/itineraries/{itinerary_id}/blocks", response_model=list[ItineraryBlockRead])
def get_blocks(itinerary_id: int, session: Session = Depends(get_session)):
    return session.exec(
        select(ItineraryBlock).where(ItineraryBlock.itinerary_id == itinerary_id)
    ).all()


# For Static Flutter Now:
@app.get("/itineraries/static", response_model=list[ItineraryStatic])
def get_static_itineraries():
    return [
        {
            "id": 1,
            "title": "7 Days in Tokyo",
            "destination": "Tokyo",
            "days": 7,
            "user_name": "Teresa",
            "likes": 567000,
            "forks": 4560,
            "saves": 45600,
            "blocks": [
                {
                    "type": "text",
                    "content": "I guess this is it! I have had some of the best time of my life here in Japan. "
                    "I visited Japan during November (which in my opinion is the best time to visit, "
                    "since the Cherry Blossom season is just so busy…). The weather is very nice during "
                    "autumn season, which is perfect for people like me, who like to walk around and do "
                    "a lot of onsen trips.\n\n"
                    "Here I am sharing my 9 days 8 nights itinerary, detailing what I did, what I ate, "
                    "where I lived, and how I travelled.",
                },
                {
                    "type": "photo",
                    "url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                },
                {
                    "type": "photo",
                    "url": "https://images.unsplash.com/photo-1549693578-d683be217e58",
                },
                {"type": "video", "url": "http://localhost:8000/static/tokyo_trip.mp4"},
            ],
        },
        {
            "id": 2,
            "title": "My Honeymoon In Bali (8 Days 7 Nights)",
            "destination": "Bali, Indonesia",
            "days": 8,
            "user_name": "Julie",
            "image_url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
            "likes": 450000,
            "forks": 4560,
            "saves": 56600,
            "blocks": [
                {
                    "type": "text",
                    "content": "My honeymoon in Bali was an absolute dream! Over eight days and sevel nights, JC and I soaked up the sunshine, "
                    "explored hidden temples, and indulged in local cuisine. "
                    "We started our adventure in Seminyak, wandering through vibrant street markets and sampling fresh coconut ice cream and spicy satay skewers. "
                    "In Ubud, we hiked the terraced rice fields at sunrise, practiced yoga overlooking lush green valleys, and attended an enchanting traditional Balinese dance performance. "
                    "On the east coast, we relaxed in natural hot springs beneath Mount Agung and snorkelled off Nusa Penida, marveling at colorful coral reefs and graceful manta rays.\n\nBetween adventures, we unwound with couples’ massages at a beachfront spa, strolled along Jimbaran Bay under starlit skies, and watched mesmerizing fire dancers swirl on the sand.\n\n"
                    "Each evening, we savored grilled ikan bakar and passionfruit cocktails at cliffside cafés, the sound of the waves forming the perfect soundtrack. Whether chasing hidden waterfalls, sharing late-night laughter over nasi campur, or simply gazing at the sunset, every moment felt utterly magical—and memories we’ll cherish for a lifetime.",
                },
                {
                    "type": "photo",
                    "url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                },
                {
                    "type": "photo",
                    "url": "https://images.unsplash.com/photo-1549693578-d683be217e58",
                },
            ],
        },
        {
            "id": 3,
            "title": "Antarctica Edge of the World Trip",
            "destination": "Antarctica",
            "days": 17,
            "user_name": "Stanley",
            "image_url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
            "likes": 1203456,
            "forks": 45600,
            "saves": 632000,
            "blocks": [
                {
                    "type": "text",
                    "content": "My honeymoon in Bali was an absolute dream! Over eight days and sevel nights, JC and I soaked up the sunshine, "
                    "explored hidden temples, and indulged in local cuisine. "
                    "We started our adventure in Seminyak, wandering through vibrant street markets and sampling fresh coconut ice cream and spicy satay skewers. "
                    "In Ubud, we hiked the terraced rice fields at sunrise, practiced yoga overlooking lush green valleys, and attended an enchanting traditional Balinese dance performance. "
                    "On the east coast, we relaxed in natural hot springs beneath Mount Agung and snorkelled off Nusa Penida, marveling at colorful coral reefs and graceful manta rays.\n\nBetween adventures, we unwound with couples’ massages at a beachfront spa, strolled along Jimbaran Bay under starlit skies, and watched mesmerizing fire dancers swirl on the sand.\n\n"
                    "Each evening, we savored grilled ikan bakar and passionfruit cocktails at cliffside cafés, the sound of the waves forming the perfect soundtrack. Whether chasing hidden waterfalls, sharing late-night laughter over nasi campur, or simply gazing at the sunset, every moment felt utterly magical—and memories we’ll cherish for a lifetime.",
                },
                {
                    "type": "photo",
                    "url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                },
                {
                    "type": "photo",
                    "url": "https://images.unsplash.com/photo-1549693578-d683be217e58",
                },
                {"type": "video", "url": "http://localhost:8000/static/tokyo_trip.mp4"},
            ],
        },
    ]

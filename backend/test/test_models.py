import pytest
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from sqlmodel import SQLModel, Session, create_engine, select
from model import User, Itinerary, ItineraryBlock

# test_engine = create_engine("sqlite://", echo=False)
test_engine = create_engine("sqlite:///itineraries.db", echo=False)


@pytest.fixture(name="julie")
def session_fixture():
    SQLModel.metadata.drop_all(test_engine)
    SQLModel.metadata.create_all(test_engine)
    with Session(test_engine) as session:
        # Create test data
        julie = User(username="julie")
        stanley = User(username="stanley")
        session.add_all([julie, stanley])
        session.commit()
        session.refresh(julie)
        session.refresh(stanley)

        # Create Itineraries data
        kyoto = Itinerary(
            title="Kyoto Trip",
            destination="Japan",
            duration="3D2N",
            user_id=stanley.user_id,
        )
        tokyo = Itinerary(
            title="Tokyo Trip",
            destination="Tokyo, Japan",
            duration="4D3N",
            user_id=julie.user_id,
        )
        session.add_all([kyoto, tokyo])
        session.commit()
        session.refresh(kyoto)
        session.refresh(tokyo)

        blocks = [
            ItineraryBlock(
                itinerary_id=kyoto.itinerary_id,
                type="text",
                content="Arrive in Kyoto and visit Fushimi Inari.",
            ),
            ItineraryBlock(
                itinerary_id=kyoto.itinerary_id,
                type="image",
                content="https://kyoto.com/photo.jpg",
            ),
            ItineraryBlock(
                itinerary_id=tokyo.itinerary_id,
                type="text",
                content="Tokyo Tower at sunset.",
            ),
        ]
        session.add_all(blocks)
        session.commit()

        yield session


def test_user_count(julie):
    users = julie.exec(select(User)).all()
    assert len(users) == 2


def test_julie_itinerary(julie):
    user = julie.exec(select(User).where(User.username == "julie")).first()
    assert user is not None
    assert len(user.itineraries) == 1
    assert user.itineraries[0].title == "Tokyo Trip"


def test_kyoto_blocks(julie):
    kyoto = julie.exec(select(Itinerary).where(Itinerary.title == "Kyoto Trip")).first()
    assert len(kyoto.blocks) == 2
    assert any(b.type == "text" for b in kyoto.blocks)
    assert any(b.type == "image" for b in kyoto.blocks)


def test_rename_typo_itinerary(julie):
    user = julie.exec(select(User).where(User.username == "julie")).one()

    typo = Itinerary(
        title="antarticaaa",
        destination="Antarctica",
        duration="5D4N",
        user_id=user.user_id,
    )
    julie.add(typo)
    julie.commit()
    julie.refresh(typo)

    # Rename it
    typo.title = "antartica"
    julie.add(typo)
    julie.commit()
    julie.refresh(typo)

    updated = julie.exec(
        select(Itinerary).where(Itinerary.title == "antartica")
    ).first()

    assert updated is not None
    assert updated.title == "antartica"
    assert updated.destination == "Antarctica"


def test_add_itinerary_for_julie(julie):
    user = julie.exec(select(User).where(User.username == "julie")).one()

    new_itinerary = Itinerary(
        title="Honeymoon with Stanley",
        destination="Bali",
        duration="7D6N",
        user_id=user.user_id,
    )
    julie.add(new_itinerary)
    julie.commit()
    julie.refresh(new_itinerary)

    result = julie.exec(
        select(Itinerary).where(Itinerary.title == "Honeymoon with Stanley")
    ).first()

    assert result is not None
    assert result.user_id == user.user_id
    assert result.title == "Honeymoon with Stanley"

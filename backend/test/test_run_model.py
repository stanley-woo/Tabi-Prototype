from sqlmodel import SQLModel, Session, create_engine, select
from sqlalchemy.orm import selectinload
from model import User, Itinerary, ItineraryBlock

sqlite_file_name = "itineraries.db"
engine = create_engine(f"sqlite:///{sqlite_file_name}", echo=False)


def create_db():
    SQLModel.metadata.drop_all(engine)
    SQLModel.metadata.create_all(engine)


def insert_data():
    with Session(engine) as session:
        alice = User(username="alice")
        bob = User(username="Bob")
        session.add_all([alice, bob])
        session.commit()
        session.refresh(alice)
        session.refresh(bob)

        # Creating Itinerary Tables
        kyoto_itinerary = Itinerary(
            title="Kyoto Trip", destination="Kyoto, Japan", duration="3D2N", creator_id=bob.id
        )
        tokyo_itinerary = Itinerary(
            title="Tokyo Trip", destination="Tokyo, Japan", duration="5D4N", creator_id=alice.id
        )
        osaka_itinerary = Itinerary(
            title="Osaka Trip", destination="Osaka, Japan", duration="3D2N", creator_id=bob.id
        )
        session.add_all([kyoto_itinerary, tokyo_itinerary, osaka_itinerary])
        session.commit()
        session.refresh(kyoto_itinerary)
        session.refresh(tokyo_itinerary)
        session.refresh(osaka_itinerary)

        # Creating Itinerary blocks
        blocks = [
            ItineraryBlock(
                itinerary_id=kyoto_itinerary.id,
                type="text",
                content="Arrive in Kyoto and visit Fushimi Inari.",
            ),
            ItineraryBlock(
                itinerary_id=kyoto_itinerary.id,
                type="image",
                content="https://kyoto.com/photo.jpg",
            ),
            ItineraryBlock(
                itinerary_id=tokyo_itinerary.id, type="text", content="Tokyo Tower at sunset."
            ),
            ItineraryBlock(
                itinerary_id=osaka_itinerary.id, type="map", content="https://goo.gl/maps/osaka123"
            ),
        ]
        session.add_all(blocks)
        session.commit()

        print("Sample data inserted.")


# def query_user_and_their_itineraries():
#     with Session(engine) as session:
#         user = session.exec(
#             select(User)
#             .where(User.username == "alice")
#             .options(selectinload(User.itineraries))
#         ).first()

#         if user:
#             print(f"\nUser: {user.username} (id: {user.id})")
#             print("Itineraries:")
#             for itinerary in user.itineraries:
#                 print(
#                     f"  - {itinerary.title} to {itinerary.destination} ({itinerary.duration})"
#                 )
#         else:
#             print("User not found.")


# def query_with_relationship():
#     with Session(engine) as session:
#         result = session.exec(
#             select(Itinerary).options(selectinload(Itinerary.creator))
#         ).first()

#         print("\n--- Loaded Itinerary ---")
#         print(f"Title: {result.title}")
#         print(f"Destination: {result.destination}")
#         print(f"Creator ID: {result.creator_id}")
#         print(f"Creator Username: {result.creator.username}")

def test_relationships():
    print("Inside test_relationships now\n")
    with Session(engine) as julie:
        users = julie.exec(select(User)).all()
        for user in users:
            print(f"\nUser: {user.username}")
            julie.refresh(user)
            for itinerary in user.itineraries:
                print(f"  📍 {itinerary.title} ({itinerary.destination})")
                julie.refresh(itinerary)
                for block in itinerary.blocks:
                    print(f"    🧱 Block [{block.type}]: {block.content}")

if __name__ == "__main__":
    create_db()
    insert_data()
    test_relationships()

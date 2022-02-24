const admin = require("firebase-admin");

const serviceAccount = require("./service-account.json");

const app = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const document = {
  fullName: "Max Mustermann",
  nickname: "mustermann",
  photoUrl:
    "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/images.jpeg?alt=media&token=c61daa6c-ea9f-4361-8074-768fc2961283",
  trips: {
    "09a37987-fd56-4416-8b39-e6895a75166e": {
      title: "Meine geile Reise",
      begin: "2022-03-01 00:00:00.000Z",
      end: "2022-03-06 00:00:00.000Z",
      companions: [],
      activities: {
        "3b4a97f7-c93f-4063-a683-7c740388121a": {
          description:
            "HANS IM GLÜCK ist vegan, vegetarisch und für Fleischliebhaber – auf der Speisekarte von HANS IM GLÜCK Stuttgart in der Marienstraße findet man pures Glück. Ob saftige Burger, frische Salate direkt aus der Küche oder erfrischende Cocktails an der Bar – hier gibt es alles was das Herz begehrt...",
          foursquareId: "5412dadb498e2f6ce24e2653",
          photoUrl:
            "https://fastly.4sqi.net/img/general/original/87388367_z4tKpfgmZ2jS2cMDTsu2gQ0t5aS6qS9rOvqdcaXq9-Q.jpg",
          title: "HANS IM GLÜCK Burgergrill & Bar",
          timestamp: "2022-03-01 06:00:00.000Z",
        },
      },
    },
  },
};

const path = "users/YeqfOe6p8Sc1QZslL4WrONxUkfX2";

const db = app.firestore();
const ref = db.doc(path);
ref.set(document);

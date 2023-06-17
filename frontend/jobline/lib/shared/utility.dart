import 'package:hive_flutter/hive_flutter.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';

String? getUserName() {
  final name = Hive.box('appBox').get('name');
  return name;
}

CurrentTimeline getDummyTimelineData() {
  return CurrentTimeline.fromJson({
    "timeline": {
      "_id": "6487505e2e88c2ae502b79eb",
      "jobTitle": "SDE3",
      "company": "GOOGLE",
      "recruiterId": "64874d8356edf81e4c1fa099",
      "steps": [
        "648a19025d001caf67b5f0e9",
        "648a19025d001caf67b5f0eb",
        "648a19025d001caf67b5f0ed",
        "648a19025d001caf67b5f0ef",
        "648a19035d001caf67b5f0f1",
        "648a19035d001caf67b5f0f3",
        "648a19035d001caf67b5f0f5",
        "648a19035d001caf67b5f0f7",
        "648a19035d001caf67b5f0f9",
        "648a19045d001caf67b5f0fb",
        "648a19045d001caf67b5f0fd",
        "648a19045d001caf67b5f0ff",
        "648a19045d001caf67b5f101",
        "648a19045d001caf67b5f103",
        "648a19055d001caf67b5f105",
        "648a19055d001caf67b5f107",
        "648a19055d001caf67b5f109",
        "648a19055d001caf67b5f10b",
        "648a19055d001caf67b5f10d"
      ],
      "jobLink": "",
      "__v": 10
    },
    "steps": [
      {
        "_id": "648a19025d001caf67b5f0e9",
        "name": "Phase 5",
        "description": "Description 5",
        "eta": 5,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 0,
        "status": [
          {
            "_id": "648835a5c47930f4e51fb89e",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "bhavishyamalhotra7@gmail.com",
            "__v": 0,
            "stepId": "648a19025d001caf67b5f0e9"
          },
          {
            "_id": "6489c32559af281c3389e208",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "sam@gmail.com",
            "__v": 0
          },
          {
            "_id": "6489c32559af281c3389e20a",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "johndoe@gmail.com",
            "__v": 0
          },
          {
            "_id": "648a1d7d790097ce43654cd5",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "dwane@gmail.com",
            "__v": 0
          },
          {
            "_id": "648a1d7d790097ce43654cd7",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "john@gmail.com",
            "__v": 0
          },
          {
            "_id": "648c71d29b2401bff2748fcc",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "sebrinaaltman002@gmail.com",
            "__v": 0
          },
          {
            "_id": "648c71d29b2401bff2748fca",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "josh123@outlook.com",
            "__v": 0
          },
          {
            "_id": "648c71d29b2401bff2748fce",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "anirudhprakash@gmail.com",
            "__v": 0
          },
          {
            "_id": "648c973777273e4c1be45a18",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "sayanthg@gmail.com",
            "__v": 0
          },
          {
            "_id": "648c973777273e4c1be45a1c",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "Danielmacravel@gmail.com",
            "__v": 0
          },
          {
            "_id": "648c973777273e4c1be45a1a",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "sarath@gmail.com",
            "__v": 0
          },
          {
            "_id": "648dec7acb84aed759155684",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "ronin@gmail.com",
            "__v": 0
          },
          {
            "_id": "648def3c73de394c3cae43f5",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "samaltman@gmail.com",
            "__v": 0
          },
          {
            "_id": "648def3c73de394c3cae43f7",
            "stepId": "648a19025d001caf67b5f0e9",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "marksukerberg@gmail.com",
            "__v": 0
          }
        ],
        "__v": 0
      },
      {
        "_id": "648a19025d001caf67b5f0eb",
        "name": "Phase 6",
        "description": "Description 6",
        "eta": 6,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 1,
        "status": [
          {
            "_id": "648d57a89ac8f2919b5ae126",
            "stepId": "648a19025d001caf67b5f0eb",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "fgfdg@fgdf.fg",
            "__v": 0
          }
        ],
        "__v": 0
      },
      {
        "_id": "648a19025d001caf67b5f0ed",
        "name": "Phase 3",
        "description": "Description 3",
        "eta": 3,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 2,
        "status": [
          {
            "_id": "648d55b26db1eeb6adaf6467",
            "stepId": "648a19025d001caf67b5f0ed",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "witwicky@gmail.com",
            "__v": 0
          },
          {
            "_id": "648d55b26db1eeb6adaf6469",
            "stepId": "648a19025d001caf67b5f0ed",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "optimus@gmail.com",
            "__v": 0
          },
          {
            "_id": "648d56665b38ed60dcb1a646",
            "stepId": "648a19025d001caf67b5f0ed",
            "stepIdx": 0,
            "timelineId": "6487505e2e88c2ae502b79eb",
            "status": "Pending",
            "email": "sdfsaf@sdfs.dfg",
            "__v": 0
          }
        ],
        "__v": 0
      },
      {
        "_id": "648a19025d001caf67b5f0ef",
        "name": "Phase 4",
        "description": "Description 4",
        "eta": 4,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 3,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19035d001caf67b5f0f1",
        "name": "Phase 6",
        "description": "Description 6",
        "eta": 6,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 4,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19035d001caf67b5f0f3",
        "name": "Phase 7",
        "description": "Description 7",
        "eta": 7,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 5,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19035d001caf67b5f0f5",
        "name": "Phase 8",
        "description": "Description 8",
        "eta": 8,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 6,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19035d001caf67b5f0f7",
        "name": "Phase 9",
        "description": "Description 9",
        "eta": 9,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 7,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19035d001caf67b5f0f9",
        "name": "Phase 10",
        "description": "Description 10",
        "eta": 10,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 8,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19045d001caf67b5f0fb",
        "name": "Phase 11",
        "description": "Description 11",
        "eta": 11,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 9,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19045d001caf67b5f0fd",
        "name": "Phase 12",
        "description": "Description 12",
        "eta": 12,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 10,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19045d001caf67b5f0ff",
        "name": "Phase 13",
        "description": "Description 13",
        "eta": 13,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 11,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19045d001caf67b5f101",
        "name": "Phase 14",
        "description": "Description 14",
        "eta": 14,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 12,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19045d001caf67b5f103",
        "name": "This is the final stage so stay tuned",
        "description": "The impossible is just possible",
        "eta": 15,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 13,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19055d001caf67b5f105",
        "name": "Phase 16",
        "description": "Description 16",
        "eta": 16,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 14,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19055d001caf67b5f107",
        "name": "Phase 17fdgjdfklgdflg",
        "description": "Description 17",
        "eta": 17,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 15,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19055d001caf67b5f109",
        "name": "Phase 18",
        "description": "Description 18",
        "eta": 18,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 16,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19055d001caf67b5f10b",
        "name": "Phase 18",
        "description": "Description 18",
        "eta": 18,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 17,
        "status": [],
        "__v": 0
      },
      {
        "_id": "648a19055d001caf67b5f10d",
        "name": "Phase 19",
        "description": "Description 19",
        "eta": 19,
        "timelineId": "6487505e2e88c2ae502b79eb",
        "order": 18,
        "status": [],
        "__v": 0
      }
    ],
    "numberOfSteps": 19
  });
}

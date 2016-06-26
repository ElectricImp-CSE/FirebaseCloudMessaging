# Google Firebase Cloud Messaging 1.0.0

Google Firebase Cloud Messaging service offers Imp agent to push notifications/messages to an application instance , a device group or application instances subscribed to certain topics. For information can be found [here](https://firebase.google.com/docs/cloud-messaging/).



## Create New Project 
Skip this section if you already have an existing Firebase project.

0. Open [Firebase Console](https://console.firebase.google.com)
0. Log in with Google account
0. Click on "CREATE NEW PROJECT"
0. Enter the preferred project name
0. Select the preferred country/region
0. Click on "CREATE PROJECT"




## Authentication

Firebase console provides the Server Key and Sender ID, passed into the following constructor’s *serverKey* and *senderId* parameter.

0. Open [Firebase Console](https://console.firebase.google.com)
0. Log in with Google account
0. Click on the relevant project
0. Click on the gear icon next to the project name on the left 
0. Click on "Project settings"
0. Select "CLOUD MESSAGING" tab
0. Copy the *Server Key* and *Sender ID* to the clipboard and paste it into the constructor.





## FirebaseCloudMessaging Class Usage

### Constructor: FirebaseCloudMessaging(*serverKey, senderId*)

This contructs a FirebaseCloudMessaging object.

The *serverKey* and *senderId* parameters are supplied by the [Firebase Console](https://console.firebase.google.com) *(see above)*.


```squirrel
// Instantiate a fcm class.
local fcm = FirebaseCloudMessaging(SERVER_KEY, SENDER_ID);
```


## FirebaseCloudMessaging Class Methods

### sendMessage(*data[, callback]*)

This method pushes a message/notification to a recipient or a group of recipients subscribed to certain topics.

*data* is a table and information on its fileds can be found [here](https://firebase.google.com/docs/cloud-messaging/http-server-ref);

*callback* is optional. If not provided , *sendMessage()* will block until its completion.

```squirrel
// send a message to a recipient
local data = {
    "to" : "RECIPIENT_REGISTRATION_TOKEN",
    "data" : {
    "message" : "A message"
    }
};
fcm.sendMessage (data,function (error,response){
    if (error) {
        server.error(error);
    } else {
        server.log(response);
    }
});


// send a message to a group of recipients subscribed to a TOPIC 
local data = {
    "to" : "/topics/TOPIC",
    "data" : {
    "message" : "A topic message"
    }
};
fcm.sendMessage (data,function (error,response){
    if (error) {
        server.error(error);
    } else {
        server.log(response);
    }
});
 
```



### manageDeviceGroup(*data[, callback]*)

This method creates a device group / assigns an app instance to a device group / removes an app instance from a device group. *sendMessage()* can be used to push message/notification to a device group . 

*data* is a table and information on its fileds can be found [here](https://firebase.google.com/docs/cloud-messaging/notifications#managing-device-groups-on-the-app-server);

*callback* is optional. If not provided , *manageDeviceGroup()* will block until its completion.

```squirrel
// create a device group
local data = {
    "operation" : "create",
    "notification_key_name" : "GROUP_NAME",
    "registration_ids" : ['DEVICE_ONE','DEVICE_TWO']
};
fcm.manageDeviceGroup (data,function (error,notification_key){
    if (error) {
        server.error(error);
    } else {
        server.log(notification_key);
    }
});


// assign an app instance to a device group
local data = {
    "operation" : "add",
    "notification_key" : "NOTIFICATION_KEY" ,
    "notification_key_name" : "GROUP_NAME",
    "registration_ids" : ['NEW_DEVICE']
};
fcm.manageDeviceGroup (data,function (error,notification_key){
    if (error) {
        server.error(error);
    } else {
        server.log(notification_key);
    }
});



// remove an app instance to a device group
local data = {
    "operation" : "remove",
    "notification_key" : "NOTIFICATION_KEY" ,
    "notification_key_name" : "GROUP_NAME",
    "registration_ids" : ['NEW_DEVICE']
};
fcm.manageDeviceGroup (data,function (error,notification_key){
    if (error) {
        server.error(error);
    } else {
        server.log(notification_key);
    }
});
 
```


### describeDevice(*registrationId, ifDetailed[, callback]*)

This method retrieves inforamtion on an app instance

*registrationId* is a string containing app instance's registration token. 

*ifDetailed* is a boolean variable. Click [here](https://developers.google.com/instance-id/reference/server) for detailed description

*callback* is optional. If not provided , *describeDevice()* will block until its completion.

```squirrel
 
fcm.describeDevice (REGISTRATION_ID,true,function (error,deviceInfo){
    if (error) {
        server.error(error);
    } else {
        server.log(appInfo);
    }
});
 
 
```

### subscribeDevicesToTopic(*registrationId, ifDetailed[, callback]*)

This method subscribes app instances to a topic

*registrationIds* an array of app instance's registration token. 

*topic* is string specifying the topic app instances subscribed to.

*callback* is optional. If not provided , *subscribeDevicesToTopic()* will block until its completion.

```squirrel
 
fcm.subscribeDevicesToTopic ([REGISTRATION_ID_1],TOPIC,function (error,response){
    if (error) {
        server.error(error);
    } else {
        server.log(response);
    }
});
 
 
```

### unsubscribeDevicesFromTopic(*registrationId, ifDetailed[, callback]*)

This method unsubscribes app instances from a topic

*registrationIds* an array of app instance's registration token. 

*topic* is string specifying the topic app instances unsubscribed from.

*callback* is optional. If not provided , *unsubscribeDevicesFromTopic()* will block until its completion.

```squirrel
 
fcm.unsubscribeDevicesFromTopic ([REGISTRATION_ID_1],TOPIC,function (error,response){
    if (error) {
        server.error(error);
    } else {
        server.log(response);
    }
});
 
 
```



### Callbacks

Callback functions passed into the above methods should be defined with the following parameters:

| Parameter | Value |
| --- | --- |
| *error* | This will be `null` if there was no error. Otherwise it will contain the error message |
| *response* | For *sendMessage()* : [result](https://developers.google.com/cloud-messaging/downstream) object<br> For *manageDeviceGroup()* : notification key <br> For *describeDevice()* : [deviceInfo](https://developers.google.com/instance-id/reference/server) <br> For *subscribeDevicesToTopic()* and *unsubscribeDevicesFromTopic()* : [response](https://developers.google.com/instance-id/reference/server#create_a_relation_mapping_for_an_app_instance) object|



## License 


This library is licensed under MIT License.

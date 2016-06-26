
/*
**@classdesc                    This class represents firebse cloud messaging and encompasses a number of methods to 
**                              send/push messages , subscribe devices to a topic and so on.
*/
class FirebaseCloudMessaging {
    
    _serverKey = null ;
    _senderId = null ;
    constructor (serverKey, senderId) {
        _serverKey = serverKey ;
        _senderId = senderId ;
    }
    
    /*
    **@methoddesc               send messages to a device / a device group / topic group
    **@parameter{table}         data: specify what and how the opeartion should be performed
    **@parameter{function}      callback: optional. If provided, this function will be invoked after the action is performed 
    */       
    function sendMessage (data,callback = null){
        local url = "https://fcm.googleapis.com/fcm/send";
        return _sendJsonRequest(url,null,data,callback);
    }
    
    /*
    **@methoddesc               create a device group / assign a device to a device group / remove a device from a device group
    **@parameter{table}         data: specify what and how the opeartion should be performed
    **@parameter{function}      callback: optional. If provided, this function will be invoked after the action is performed 
    */   
    function manageDeviceGroup ( data,callback = null) {
        local extraHeader = {
            "Authorization" : "key=" + _serverKey + "\n" + "project_id :" + _senderId  ,
        }; 
        local url = "https://android.googleapis.com/gcm/notification";
        return _sendJsonRequest(url,extraHeader,data,callback);
    }
    
    /*
    **@methoddesc               retrieve information on the device (app instance)
    **@parameter{string}        registrationId: the device's registration token
    **@parameter{boolean}       ifDetailed: if retrieve extra information
    **@parameter{function}      callback: optional. If provided, this function will be invoked after the action is performed 
    */
    function describeDevice ( registrationId,ifDetailed,callback = null) {
        local url = "https://iid.googleapis.com/iid/info/" + registrationId + "?details=" + ifDetailed;
        return _sendJsonRequest(url,null,null,callback); 
    }
    
    /*
    **@methoddesc               this method subscribes devices to a topic
    **@parameter{string}        registrationIds: an array of registration tokens
    **@parameter{string}        topic: the topic devices subscribed to
    **@parameter{function}      callback: optional. If provided, this function will be invoked after the action is performed 
    */
    function subscribeDevicesToTopic (registrationIds,topic,callback = null){
        local data = {
            "registration_tokens" : registrationIds,
            "to" : "/topics/" + topic ,
        };
        local url = "https://iid.googleapis.com/iid/v1:batchAdd";
        return _sendJsonRequest(url,null,data,callback); 
    }
    
    
    /*
    **@methoddesc               this method unsubscribes devices from a topic
    **@parameter{string}        registrationIds: an array of registration tokens
    **@parameter{string}        topic: the topic devices unsubscribed from
    **@parameter{function}      callback: optional. If provided, this function will be invoked after the action is performed 
    */
    function unsubscribeDevicesFromTopic (registrationIds, topic , callback = null) {
        local data = {
            "registration_tokens" : registrationIds,
            "to" : "/topics/" + topic ,
        };
        local url = "https://iid.googleapis.com/iid/v1:https://iid.googleapis.com/iid/v1:batchRemove";
        return _sendJsonRequest(url,null,data,callback); 
    }
    
    //***************************** PRIVATE METHODS *********************************
    
    /*
    **@methoddesc               this method wraps up the logic to send a post request in JSON format
    **@parameter{string}        url: the url the request sent to 
    **@parameter{table}         extraHeader: set new header or overwrite exisiting header
    **@parameter{table}         body: the data the request contains 
    **@parameter{function}      callback: optional. If provided, this function will be invoked after the action is performed
    */
    function _sendJsonRequest (url,extraHeader,body,callback) {
        // predefined header , can be overwritten if necessary
        local header = {
            "Content-Type" : "application/json",
            "Authorization": "key=" + _serverKey ,
        };
        if (extraHeader) {
            foreach(key,value in extraHeader) {
                if (key in header) {
                    header[key] = extraHeader[key]; // if the field exists , overwrite
                } else {
                    header[key] <- extraHeader[key];// otherwise, create a new slot 
                }
            }
        }
        local request = http.post(url,header,http.jsonencode(body));
        if (callback) {
            request.sendasync(function(response){
                local data ;
                try { // try to decode JSON object
                  data = http.jsondecode(response.body);
                } catch (error) {
                  data = response.body ;
                } 
                if (response.statuscode >= 200 && response.statuscode < 300) {
                    callback(null,data);
                } else {
                    if ("error" in data) {
                        callback(data.error,null);
                    } else {
                        callback(data,null);
                    }
                }
            }.bindenv(this));
        } else {
            local response = request.sendsync();
            local data ;
            try {
                data = http.jsondecode(response.body);
            } catch (error) {
                data = response.body;
            }
            if (response.statuscode >= 200 && response.statuscode < 300) {
                return data ;
            } else {
                if ("error" in data) {
                    throw data.error ;
                } else {
                    throw data ;
                }
            }
        }
    }
}

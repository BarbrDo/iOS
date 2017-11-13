//
//  Constant.swift
//  BarbrDo
//
//  Created by Vishwajeet Kumar on 5/11/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import Foundation

enum UserType: String{
    case Customer = "customer"
    case Barber = "barber"
    case Shop   = "shop"
}

/***************** Notification Constants***************************/

let KCustomerRequestToBarber =  "customer_request_to_barber"
let KBarberConfirmAppointment = "barber_confirm_appointment"
let KStopCustomerTimer = "StopCustomerTimer"
let KBarberCancelAppointment = "barber_cancel_appointment"
let KBarberCompletedAppointment = "barber_complete_appointment"

let KCustomerCancelAppointmentNot = "customer_cancel_appointment"
let KMessageToCustomer  =   "message_to_customer"
let KMessageToBarber    =   "message_to_barber"
let KReloadAgain    = "Reload Again"


let KBarberDeclineRequest = "BarberDeclineRequest"


/***************** API Request Constants***************************/

let KGoogleMaps = "AIzaSyBvnLv5speGI11w49876BGfszXq_PDkO4M"
let  KLatitude  = "device_latitude"
let  KLongitude = "device_longitude"
let  KUserID    = "user_id"
let  KBarberID  = "barber_id"
let  KCustomerID = "customer_id"
let  KBarberServiceID = "barber_service_id"
let  KAppointmentID = "appointment_id"
let  KImageID           = "image_id"
let  KDeviceType = "device_type"
let  KDeviceID = "device_id"
let  KUserType = "user_type"
let  KAuthorization = "Authorization"
let  KBearer =  "Bearer "
let  KiOS = "iOS"


let KFirstName = "first_name"
let KLastName = "last_name"
let KMobileNumber = "mobile_number"
let KPassword = "password"
let KConfirm = "confirm"
let KType = "type"
let KEmail  = "email"
let KRadiusSearch = "radius_search"

/***************** Loader Text***************************/

let KUpdating = "Updating..."
let KFetchingLocation = "Fetching Location..."
let KLoading = "Loading..."
let KUpdatingPrice = "Updating Price"
let KLoadingActiveServices = "Loading Active Services..."
let KConfirmAppointmentText = "Confirm Appointment"

/*******************  Structures  ********************************/
public struct BRDKey {
    public static let message          =    "msg"

}

public let customerStoryboard          =     "Customer"
public let barberStoryboard            =     "Barber"
public let shopStoryboard              =     "Shop"
public let loginStoryboard             =     "Login"

public let KLocationServiceOFF          =       "LocationServicesOff"
/**********************************************************/


/***************** Alert Message ********************************/
public let KAlertTitle                 =    "BarbrDo"
public let KInternetConnection         =    "Internet connection not available."
public let KServerError                =    "An error occurred, Please try again."
public let KSelectBarberServices        = "Kindly select barber services"
/****************************************************/



public let imageUpdated = "ImageUpdated"
public let monthly : String = "monthly"
public let weekly :String = "weekly"
public let closed : String  = "closed"
public let available : String = "available"
public let booked : String = "booked"
public let percentage : String = "percentage"

public let KPaymentReceived: String = "Payment Received"
public let KPaymentDue: String = "Payment Due"
public let KPaymentStatusPending = "pending"


public let KPasswordValidation = "Password and confirm password do not match"
public let KPasswordAndConfirmValidation = "Minimum 6 characters required for password and confirm password"

public let KUpdatedSuccessfully = "Updated successfully"
public let KProfileUpdatedSuccessfully = "Profile updated successfully"
public let KPleaseTryAgainLater = "Please try again later"

public let KChooseOption = "Choose Option"
public let KPhotoLibrary = "Photo Library"
public let KCamera = "Camera"






















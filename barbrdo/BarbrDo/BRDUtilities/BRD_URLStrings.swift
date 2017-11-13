//
//  BRD_URLStrings.swift
//  BarbrDo
//
//  Created by Sumit Sharma on 13/05/17.
//  Copyright © 2017 Sumit Sharma. All rights reserved.
//

import UIKit


// ALLOWED CHARACTERS
let KCharacterset = CharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")

let KCancelAlertTitle = "Cancel Request"
let KCancelAlertText = "Are you sure you want to cancel this request?"


//let KGooglePlaceAPIKey = "AIzaSyBWFq_UoUG_zusW-CL2nRXhwqhPQ8gVpuc"
let KGooglePlaceAPIKey = "AIzaSyDvdip8Rb5DveHCWWgVuGBMXqnzPn0ONL8"
// hussain
//let KImagePathForServer    = "http://172.24.5.248:3000/uploadedFiles/"
//let KBaseURLString         = "http://172.24.5.248:3000/api/v2/"

//ankush
//let KImagePathForServer      = "http://172.24.4.182:3000/uploadedFiles/"
//let KBaseURLString           = "http://172.24.4.182:3000/api/v2/"


let KNotificationReloadMaps = "ReloadMaps"

//// client
//let KImagePathForServer      = "http://52.39.212.226:4062/uploadedFiles/"
//let KBaseURLString           = "http://52.39.212.226:4062/api/v2/"

// Live Server
//104.236.47.120
let KImagePathForServer      = "http://app.barbrdo.com/uploadedFiles/"
let KBaseURLString           = "http://app.barbrdo.com/api/v2/"

let KSignUpURL               =   "signup"
let KLoginURL                =   "login"
let KForgotURL               =   "forgot"
let KGetAllAppointmentURL    =   "appointment"
let KcheckFaceBookURL        =   "checkFaceBook"
let KViewAllShopsURL         =   "shops"
let KViewAllBarbersURL       =   "barbers"
let KTimeSlotsURL            =   "timeslots"
let KShopDetailsURL          =   "shops/barbers/"
let KGetUserProfileURL       =   "userprofile/"
let KBarberAppointmentsURL   =   "barber/appointments/"
let KAcceptCustomerRequest   =    "barber/appointment/accept/"
let KDeclineCustomerRequest  =    "barber/appointment/decline/"

let KGetBarberDetailURL     =    "barbers/"
let KBarberDetail           =   "barberdetail/"

let KAccount                =    "account"
let KBarberServices         =    "barber/services/"

let KActiveServices         =    "barber/services"
let kAddService             =    "barber/services"
let KDeleteServices         =    "barber/services/"
let KConfirmAppointment     =    "barber/confirmappointment/"
let KCompleteAppointment    =    "barber/completeappointment/"
let KCancelAppointment      =    "barber/cancelappointment/"
let KRescheduleAppointment  =    "barber/rescheduleappointment/"
let KDeleteImage            =    "customer/gallery/"

let kNewWebService          =   "barber/shops/chair"

let KRequestChair           =    "requestchair"
//let KGetAllChairs           =    "shops/chair"

let kGetAllShop             =   "barber/shops"
let KSubscriptionPlans      =   "plan"
let KUpdateSubscribePLan    =   "subscribe"

let KBarberGoOnline       =   "barber/goOnline"
let KBarberGoOffline        =   "barber/goOffline"
let KBarberHome             =   "barber/home"
let KCustomerCheckIN        =   "barber/checkin/"
let KCustomerAppointmentDetails = "customer/appointment"

let KFetchAllBarbers        =   "customer/barbers"
let KFavoriteBarbers        =   "customer/favouritebarber"
let KRemoveFavoriteBarber   =   "customer/favouritebarber/"
let KCustomerTimeSlots      =   "customer/timeSlots"
let KCustomerNewRequest     =   "customer/appointment/newrequest"
let KCustomerCancelAppointment = "customer/appointment/cancel/"

let KManageChair            =    "shops/managechair"
let KAddChairShop           =    "shops/chair"
let KPostchairtoallbarbers  =    "shops/postchairtoallbarbers"
let KDeleteChairShop        =    "shops/chair"
let KShopsList              =    "shops/chair"
let KUserProfile            =    "userprofile/"
let KContact                =     "contact"
let KContactShopFromBarber  =     "barber/contactshop"
let KShopchairrequests      =     "barber/shopchairrequests"
let KAddAssociatedSHop  =   "barber/shop"

let KCustomerSendMessageToBarber =  "customer/messageToBarber"
let KBarberSendMessageToCustomer =  "barber/messageToCustomer"
let KAppToRefer =   "referapp"

let KMakeDefaultShop        =   "barber/makeDefaultshop"

let KShopRequest            =   "shop/request"
let KGetAllStates            =   "states"

let kContactBarber          =      "barber/rescheduleappointment/"
//"contactbarber"
// UIAlert
 let KApplicationTitle      =     "BarbrDo"
let KCameraAlert            =     "Device does not support camera"
let KLocationServices       =     "Kindly enable location services from the settings"

let KMemberSince                 =   "Member Since: "
let KAppointmentDetails          =   "Appointment Details"
let KPendingAppointmentDetail    =   "Pending Appointment Detail"
let KGallery                     =   "Gallery"
let KSearchForChair              =   "What day are you looking for?"
let KManageServices              =   "Manage Services"
let KManageMyServices            =   "Manage My Services"
let KCompleteAppointmentDetails  =   "Completed Appointment Details"
let KUpcomingAppointmentDetails  =   "Upcoming Appointment Details"
let KConfirmedAppointmentDetails =  "Confirmed Appointment Details"
let KPendingAppointmentDetails   =  "Pending Appointment Details"
let KManageChairs                =  "Manage Chairs"
let KPayDuringYourVisit          =  "Pay During Your Visit"
let KUpdateShopDetails           =   "shops"
let KGetAllEvents                =  "barber/event/"

let KShopDetail                 =   "shopdetail/"

let KShopSearch                  =   "shops?search="

let KBarberShopSearch             =   "barbers/available?search="
let KMarkChairAsBooked            =   "shops/markchairasbooked"
let KBarberSearch                 =   "barbers/available"

let kbarberchairrequests          =    "shops/barberchairrequests"
let KAcceptRejectRequest          =    "shops/acceptrequest"
let kShopchairrequests            =    "barber/shopchairrequests"
let KRequestChairToBarberShop     =    "requestchair"

let KDeleteAssociatedShop       =   "barber/associatedshops"

let KRateBarber = "rateBarber"
let KAddBarberEvent = "barber/event"
let kBarberSale = "barber/sale"
let kShopSale = "shops/sale"
let KShopRemoveBarber = "shops/removebarber"
let KPostCustomerCharges = "appointment"
let KPayAfterAppointment  = "customer/payafterappointment"
let kLogOut = "logout"

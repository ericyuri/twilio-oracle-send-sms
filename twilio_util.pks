create or replace package twilio_util as

  procedure send_sms(p_user     IN VARCHAR2, -- Twilio user name
                     p_pass     IN VARCHAR2, -- Twilio password
                     p_from     IN VARCHAR2, -- Twilio From phone number
                     p_to       IN VARCHAR2, -- List of Phone number colon delimited.
                     p_sms_body IN VARCHAR2);

end twilio_util;
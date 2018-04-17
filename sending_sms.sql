DECLARE
  lv_twilio_user_name     VARCHAR2(300) := apex_var.f_fetch_apex_setting(p_param   => 'APEX_TWILIO_USER'); --- I put in a table a side
  lv_twilio_password      VARCHAR2(300) := apex_var.f_fetch_apex_setting(p_param   => 'APEX_TWILIO_PW'); --- I put in a table a side
  lv_twilio_from_phone_no VARCHAR2(300) := '+15555555555'; --- Twilio is going to provide this number for you
  lv_cust_phone_no        VARCHAR2(300) := '+15555555501:+15555555501';
  lv_msg_body             VARCHAR2(1000):= 'Hello You. I am sending SMS using Twilio API.';
BEGIN
  -- Get Twilio credentials from setup table
  -- Get welcome SMS body from setup table
  -- Get new customer phone number
  send_sms(lv_twilio_user_name,
           lv_twilio_password,
           lv_twilio_from_phone_no,
           lv_cust_phone_no,
           lv_msg_body);
END;
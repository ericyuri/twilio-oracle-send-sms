create or replace package body twilio_util as

/**
 * Description: send sms message to the recipients
 *
 *
 * @author: Eric Sacramento
 * @created: 12-April-2018
 * @param: p_user apex_var.f_fetch_apex_setting(p_param   => 'APEX_TWILIO_USER')
 * @param: p_pass apex_var.f_fetch_apex_setting(p_param   => 'APEX_TWILIO_PW')
 * @param: p_from apex_var.f_fetch_apex_setting(p_param   => 'APEX_TWILIO_SENDER') 
 * @param: p_to
 * @param: p_sms_body
 */

 procedure send_sms(p_user     in varchar2, -- Twilio user name
                    p_pass     in varchar2, -- Twilio password
                    p_from     in varchar2, -- Twilio From phone number
                    p_to       in varchar2, -- List of Phone number colon delimited.
                    p_sms_body in varchar2) is

  t_http_req       utl_http.req;
  t_http_resp      utl_http.resp;
  lv_resp_line     varchar2(32767);
  lv_response_text clob;
  v_url            varchar2(500) := 'https://api.twilio.com/2010-04-01/Accounts/'||p_user||'/Messages.xml';
  lv_post_params   varchar2(30000);
  lv_from          varchar2(100);
  lv_to            varchar2(100);
  lv_sms_body      varchar2(30000);
  c_xml_response   clob;
  lv_recipients apex_application_global.vc_arr2;

begin
  dbms_output.put_line('begin');
  c_xml_response := null;
  lv_from        := p_from;
  lv_sms_body    := p_sms_body;
  lv_recipients  := apex_util.string_to_table(p_to, ':');

  for i in 1 .. lv_recipients.count loop

    lv_post_params := 'From=' || lv_from || '=' || lv_recipients(i) || '=' ||
                      lv_sms_body;

    lv_post_params := utl_url.escape(lv_post_params);
    v_url          := utl_url.escape(v_url);

    apex_node.set_wallet;

    t_http_req := utl_http.begin_request(v_url, 'POST', 'HTTP/1.1');

    utl_http.set_authentication(t_http_req, p_user, p_pass);
    utl_http.set_header(t_http_req,'Content-Type','application/x-www-form-urlencoded');
    utl_http.set_header(t_http_req,
                        'Content-Length',
                        length(lv_post_params));
    utl_http.write_text(t_http_req, lv_post_params);

    t_http_resp := utl_http.get_response(t_http_req);

    utl_http.read_text(t_http_resp,lv_response_text);   
    utl_http.end_response(t_http_resp);

    dbms_output.put_line(lv_response_text);

    lv_response_text := null;
  end loop;

 exception
   when others then
      dbms_output.put_line('An error was encountered - '||sqlcode||' -ERROR- '||sqlerrm||utl_http.get_detailed_sqlerrm);  

end send_sms;


end twilio_util;
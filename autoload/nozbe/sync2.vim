
let s:api_base_url = "http://dev.webapp.nozbe.com/sync2/"


function! nozbe#sync2#call_api(method, attr)
    let api_url = s:api_base_url . a:method
    let a:attr['app_key'] = "MF5dMyqHem" " key for termoshtt
    let a:attr['key'] = g:nozbe_api_key
    let header = {"Content-Type": "application/json"}
    let param_json = webapi#json#encode(a:attr)
    let response = webapi#http#post(api_url, param_json, header)
    let g:nozbe_debug_response = webapi#json#decode(response['content'])
    return g:nozbe_debug_response
endfunction

" Get api_key interactively to save to g:nozbe_api_key
function! nozbe#sync2#login()
    let email = input('Enter email for Nozbe.com: ')
    let passwd = inputsecret(printf('Enter Password for Nozbe.com (%s): ', email))
    let md5_passwd = md5#md5(passwd)
    let attr = {
    \   "email": email,
    \   "password": md5_passwd,
    \ }
    let res = nozbe#sync2#call_api("login", attr)
    if !has_key(res, "key")
        echoerr "Login Failed"
        echo res["error"]
    else
        let g:nozbe_api_key = res["key"]
    endif
endfunction

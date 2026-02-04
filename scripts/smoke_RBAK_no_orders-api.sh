echo "TOKEN_ORDERS_M2M_LEN=${#TOKEN_ORDERS_M2M}"
python3 - <<'PY'
import os, json, base64
t=os.environ["TOKEN_ORDERS_M2M"]
p=t.split(".")[1]
p += "="*((4-len(p)%4)%4)
p=p.replace("-","+").replace("_","/")
c=json.loads(base64.b64decode(p).decode())
ok_iss = c.get("iss","").endswith("/realms/asrp")
aud = c.get("aud",[])
roles = c.get("resource_access",{}).get("asrp-orders",{}).get("roles",[])
print("iss_ok:", ok_iss)
print("aud_has_asrp-orders:", "asrp-orders" in (aud if isinstance(aud,list) else [aud]))
print("has_orders_read:", "orders_read" in roles)
PY

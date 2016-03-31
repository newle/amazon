# *-* encoding=utf8 *-*
# Import smtplib for the actual sending function
import smtplib

# Import the email modules we'll need
from email.mime.text import MIMEText

from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
import mimetypes
from email import encoders
import os
def add_attach(msgs, directory, filename, showout=False):
    path = os.path.join(directory, filename)
    if not os.path.isfile(path):
        return False 
    # Guess the content type based on the file's extension.  Encoding
    # will be ignored, although we should check for simple things like
    # gzip'd or compressed files.
    ctype, encoding = mimetypes.guess_type(path)
    if ctype is None or encoding is not None:
        # No guess could be made, or the file is encoded (compressed), so
        # use a generic bag-of-bits type.
        ctype = 'application/octet-stream'
    maintype, subtype = ctype.split('/', 1)
    if maintype == 'text':
        fp = open(path)
        # Note: we should handle calculating the charset
        msg = MIMEText(fp.read(), _subtype=subtype)
        fp.close()
    elif maintype == 'image':
        fp = open(path, 'rb')
        msg = MIMEImage(fp.read(), _subtype=subtype)
        fp.close()
    elif maintype == 'audio':
        fp = open(path, 'rb')
        msg = MIMEAudio(fp.read(), _subtype=subtype)
        fp.close()
    else:
        fp = open(path, 'rb')
        msg = MIMEBase(maintype, subtype)
        msg.set_payload(fp.read())
        fp.close()
        # Encode the payload using Base64
        encoders.encode_base64(msg)
    # Set the filename parameter
    if not showout:
        msg.add_header('Content-Disposition', 'attachment', filename=filename)
    msgs.attach(msg)
    return True

import time
import sys, getopt
def usage():
    print """
            python sendmail.py [hf:t:a:s:c]
              h : 打印帮助信息
              f : 发件人
              t : 收件人 - 用逗号分割
              a : 附件 - 用逗号分割
              s : 标题
              c : 正文来源文件
    """
if __name__ == "__main__":
    msg = MIMEMultipart()

    me = "newle.hit@gmail.com"
    you = "349719570@qq.com"
    msg['Subject'] = "测试时间点:" + time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
    msg['From'] = me
    msg['To'] = you 

    opts, args = getopt.getopt(sys.argv[1:], "hf:t:a:s:c:")
    for op, value in opts:
        if op == "-f":
            del msg['From']
            msg['From'] = value
        elif op == "-t":
            del msg['To']
            msg['To'] = value
        elif op == "-a":
            attaches = value.split(";")
            for att in attaches:
               add_attach(msg, "./", att)
        elif op == "-c":
            add_attach(msg, "./", value, showout=True)
        elif op == "-s":
            msg['Subject'] = value  
        elif op == "-h":
            usage()
            sys.exit()
    

    s = smtplib.SMTP('127.0.0.1')
    s.sendmail(msg['From'], msg['To'].split(";"), msg.as_string())
    s.quit()

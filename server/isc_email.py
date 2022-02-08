import smtplib,ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
def email(receiver,data,status,user):
    sender='picasabackup123@gmail.com'
    password='Lollipop2806'
    message = MIMEMultipart("alternative")
    message["Subject"] = "ISC booking "+status
    message["From"] = sender
    message["To"] = receiver
    color='#61bd00' if str(status).lower=='Cancelled' else '#4cc300'
    text='Hi'
    html='''\
        <!DOCTYPE html>
    
    <html lang="en" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:v="urn:schemas-microsoft-com:vml">
    <head>
    <title></title>
    <style>
    		* {
    			box-sizing: border-box;
    		}
    
    		body {
    			margin: 0;
    			padding: 0;
    		}
    
    		a[x-apple-data-detectors] {
    			color: inherit !important;
    			text-decoration: inherit !important;
    		}
    
    		#MessageViewBody a {
    			color: inherit;
    			text-decoration: none;
    		}
    
    		p {
    			line-height: inherit
    		}
    
    		@media (max-width:520px) {
    			.icons-inner {
    				text-align: center;
    			}
    
    			.icons-inner td {
    				margin: 0 auto;
    			}
    
    			.row-content {
    				width: 100% !important;
    			}
    
    			.stack .column {
    				width: 100%;
    				display: block;
    			}
    		}
    	</style>
    </head>
    <body style="background-color: #FFFFFF; margin: 0; padding: 0; -webkit-text-size-adjust: none; text-size-adjust: none;">
    <table border="0" cellpadding="0" cellspacing="0" class="nl-container" role="presentation" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt; background-color: #FFFFFF;" width="100%">
    <tbody>
    <tr>
    <td>
    <table align="center" border="0" cellpadding="0" cellspacing="0" class="row row-1" role="presentation" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt;" width="100%">
    <tbody>
    <tr>
    <td>
    <table align="center" border="0" cellpadding="0" cellspacing="0" class="row-content stack" role="presentation" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt; color: #000000; width: 500px;" width="500">
    <tbody>
    <tr>
    <td class="column" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt; font-weight: 400; text-align: left; vertical-align: top; padding-top: 5px; padding-bottom: 5px; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px;" width="100%">
    <table border="0" cellpadding="10" cellspacing="0" class="text_block" role="presentation" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt; word-break: break-word;" width="100%">
    <tr>
    <td>
    <div style="font-family: sans-serif">
    <div style="font-size: 12px; mso-line-height-alt: 14.399999999999999px; color: '''+color+'''; line-height: 1.2; font-family: Arial, Helvetica Neue, Helvetica, sans-serif;">
    <p style="margin: 0; font-size: 12px; text-align: center;"><span style="font-size:50px;">'''+str(status)+'''</span></p>
    </div>
    </div>
    </td>
    </tr>
    </table>
    <table border="0" cellpadding="10" cellspacing="0" class="divider_block" role="presentation" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt;" width="100%">
    <tr>
    <td>
    <div align="center">
    <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt;" width="100%">
    <tr>
    <td class="divider_inner" style="font-size: 1px; line-height: 1px; border-top: 1px solid #BBBBBB;"><span> </span></td>
    </tr>
    </table>
    </div>
    </td>
    </tr>
    </table>
    <table border="0" cellpadding="5" cellspacing="0" class="text_block" role="presentation" style="mso-table-lspace: 0pt; mso-table-rspace: 0pt; word-break: break-word;" width="100%">
    <tr>
    <td>
    <div style="font-family: sans-serif">
    <div style="font-size: 14px; mso-line-height-alt: 16.8px; color: #555555; line-height: 1.2; font-family: Arial, Helvetica Neue, Helvetica, sans-serif;">
    <p style="margin: 0; font-size: 14px; text-align: center;">Your booking for '''+ str(data) + ''' has been '''+str(status)+''' by '''+str(user)+'''</p>
    </div>
    </div>
    </td>
    </tr>
    </table>
    </td>
    </tr>
    </tbody>
    </table>
    </td>
    </tr>
    </tbody>
    </table>
    </td>
    </tr>
    </tbody>
    </table>
    </body>
    </html>
    '''
    part1=MIMEText(text,'plain')
    part2=MIMEText(html,'html')
    message.attach(part1)
    message.attach(part2)
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(sender, password)
        server.sendmail(
            sender, receiver, message.as_string()
        )

#include <SPI.h>
#include <MFRC522.h>
 
#define SS_PIN    21
#define RST_PIN   22
 
#define SIZE_BUFFER     18
#define MAX_SIZE_BLOCK  16
 
#define LED_BUILTIN 2 //LED EMBEDDED
 
MFRC522 mfrc522(SS_PIN, RST_PIN);
 







void setup()
{
  // Inicia a serial
  Serial.begin(9600);
  // Inicia  SPI bus 
  SPI.begin();
  // Inicia MFRC522    
  mfrc522.PCD_Init();
  Serial.println("Aproxime o seu cartao/TAG do leitor");
  Serial.println();
  pinMode(LED_BUILTIN, OUTPUT);





}



 
void loop()
{ 

   
          // Busca novos cartões 
          if ( ! mfrc522.PICC_IsNewCardPresent())
          {
            return;
          }
          // Seleciona um catão a ser lido
          if ( ! mfrc522.PICC_ReadCardSerial())
          {
            return;
          }
          //Mostra ID na serial
          String conteudo = "";
          for (byte i = 0; i < mfrc522.uid.size; i++)
          {
            Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : "");
            Serial.print(mfrc522.uid.uidByte[i], HEX);
            conteudo.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : ""));
            conteudo.concat(String(mfrc522.uid.uidByte[i], HEX));
            conteudo.toUpperCase();

          }
          
          Serial.println();

          

          digitalWrite(LED_BUILTIN, HIGH);
          delay(2000);
          digitalWrite(LED_BUILTIN, LOW);
          delay(2000);



       
}

String? usrInputValidationFunction(String value, String errorMessage)
{
   if(value.trim().isEmpty)
     {
         return errorMessage;
     }
   return null;
}
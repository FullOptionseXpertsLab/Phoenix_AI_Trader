//+------------------------------------------------------------------+
//|                                                PhoenixVersion.mqh |
//|                       PHOENIX AI TRADER - Foundation Core        |
//|                                                                  |
//|  Module : Version Management                                     |
//|  Version: Alpha 0.1.0                                            |
//|  Build  : 20260809                                               |
//+------------------------------------------------------------------+
#ifndef __PHOENIX_VERSION_MQH__
#define __PHOENIX_VERSION_MQH__

//--- Project identity
#define PHOENIX_PRODUCT_NAME       "PHOENIX AI TRADER"
#define PHOENIX_PRODUCT_SHORT_NAME "PHOENIX"
#define PHOENIX_VENDOR_NAME        "FullOptionsExPertsLab"

//--- Semantic version
#define PHOENIX_VERSION_MAJOR      0
#define PHOENIX_VERSION_MINOR      1
#define PHOENIX_VERSION_PATCH      0

//--- Release stage
#define PHOENIX_RELEASE_STAGE      "ALPHA"

//--- Build identifier
#define PHOENIX_BUILD_NUMBER       20260809

//--- Version string
#define PHOENIX_VERSION_STRING     "0.1.0"
#define PHOENIX_BUILD_STRING       "20260809"

//+------------------------------------------------------------------+
//| Version information container                                    |
//+------------------------------------------------------------------+
class CPhoenixVersion
  {
public:
   //--- Product information
   static string ProductName()
     {
      return PHOENIX_PRODUCT_NAME;
     }

   static string ProductShortName()
     {
      return PHOENIX_PRODUCT_SHORT_NAME;
     }

   static string VendorName()
     {
      return PHOENIX_VENDOR_NAME;
     }

   //--- Version information
   static int Major()
     {
      return PHOENIX_VERSION_MAJOR;
     }

   static int Minor()
     {
      return PHOENIX_VERSION_MINOR;
     }

   static int Patch()
     {
      return PHOENIX_VERSION_PATCH;
     }

   static int Build()
     {
      return PHOENIX_BUILD_NUMBER;
     }

   static string Stage()
     {
      return PHOENIX_RELEASE_STAGE;
     }

   static string Version()
     {
      return PHOENIX_VERSION_STRING;
     }

   static string BuildString()
     {
      return PHOENIX_BUILD_STRING;
     }

   //--- Full display version
   static string FullVersion()
     {
      return StringFormat("%s %s %s (Build %s)",
                          PHOENIX_PRODUCT_NAME,
                          PHOENIX_RELEASE_STAGE,
                          PHOENIX_VERSION_STRING,
                          PHOENIX_BUILD_STRING);
     }

   //--- Compact version
   static string ShortVersion()
     {
      return StringFormat("v%s", PHOENIX_VERSION_STRING);
     }

   //--- Diagnostic banner
   static string DiagnosticHeader()
     {
      return StringFormat(
         "========================================\n"
         "%s\n"
         "Stage : %s\n"
         "Version: %s\n"
         "Build : %s\n"
         "Vendor: %s\n"
         "========================================",
         PHOENIX_PRODUCT_NAME,
         PHOENIX_RELEASE_STAGE,
         PHOENIX_VERSION_STRING,
         PHOENIX_BUILD_STRING,
         PHOENIX_VENDOR_NAME
      );
     }
  };

#endif // __PHOENIX_VERSION_MQH__
//+------------------------------------------------------------------+

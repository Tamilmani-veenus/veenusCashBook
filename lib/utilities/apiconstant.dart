import 'dart:io';

class ApiConfig {
  static const String LIVE_ENDPOINT_CORE = "http://49.204.233.151:8080/";    //local

  static const String DEFAULT_BASE_URL_CORE = LIVE_ENDPOINT_CORE + "veenuscashbookapi/";
  static late final String APIURL_CORE;

  static late final String WebURL;
  static String BASE_URL_CORE = APIURL_CORE;

  static Future<void> initializeUrl() async {
    final isLive = await _isEndpointLive(Uri.parse(LIVE_ENDPOINT_CORE).host);
    if (isLive) {
      APIURL_CORE = "${LIVE_ENDPOINT_CORE}veenuscashbookapi/";
    } else {
      APIURL_CORE = DEFAULT_BASE_URL_CORE;
    }
  }

  static Future<bool> _isEndpointLive(String ip) async {
    try {
      final socket = await Socket.connect(ip, 80, timeout: Duration(seconds: 5));
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class ApiConstant{

  static String BASE_URL_CORE = ApiConfig.BASE_URL_CORE;
  static String Web_URL = ApiConfig.WebURL;

  /// ---- Get API's ----

  static String GETCOMPANY_DETAILSLIST = BASE_URL_CORE + "api/Company/CompanyDetailsGetAll";
  static String GETDROPDOWN_CITYLIST = BASE_URL_CORE + "api/Sales/GetAllCity";




  static String EDIT_BILLBOQ_API = BASE_URL_CORE + "api/SubContractorWorkQtyBOQ/GetSubContractorWorkQtyById";



  /// ----- Put API's -----

  static String PUTCOMPANYDETAILS_API = BASE_URL_CORE + "api/Company/updateCompany";



  /// ----- POST API's -----

  static String COMPANYDETAILS_SAVEAPI = BASE_URL_CORE + "api/Company/AddCompany";

  /// ----- Delete API's -----
  static String COMPANYDETAILS_DELETE = BASE_URL_CORE + "api/Company/DeleteCompanyDetail";

}

import 'dart:io';



class ApiConfig {
  static const String LIVE_ENDPOINT_1 = "http://49.204.233.151:8080/";
  static const String LIVE_ENDPOINT_2 = "http://122.173.84.247:8080/";

  static const String DEFAULT_BASE_URL = LIVE_ENDPOINT_1 + "veenuscashbookapi/";

  static late final String APIURL;

  static Future<void> initializeUrl() async {
    final liveEndpoint = await _getLiveEndpoint();
    if (liveEndpoint != null) {
      APIURL = "${liveEndpoint}veenuscashbookapi/";
      print("IP_URL ${APIURL}");
    } else {
      APIURL = DEFAULT_BASE_URL;
    }
  }

  static String BASE_URL = APIURL;

  static Future<String?> _getLiveEndpoint() async {
    final ip1 = Uri.parse(LIVE_ENDPOINT_1).host;
    final ip2 = Uri.parse(LIVE_ENDPOINT_2).host;

    if (await _isEndpointLive(ip1)) {
      return LIVE_ENDPOINT_1;
    } else if (await _isEndpointLive(ip2)) {
      return LIVE_ENDPOINT_2;
    }
    return null; // No live endpoint found
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

  static String BASE_URL_CORE = ApiConfig.BASE_URL;


  /// ---- Get API's ----

  static String GETAUTONO_YEAR_WISE = BASE_URL_CORE + "api/Company/GetAutoNoWithoutyearwise";

  static String GETCOMPANY_DETAILSLIST = BASE_URL_CORE + "api/Company/CompanyDetailsGetAll";
  static String GETSALES_DETAILSLIST = BASE_URL_CORE + "api/Sales/GetAllSales";
  static String GETRECEIPT_DETAILSLIST = BASE_URL_CORE + "api/Receipt/GetAllReceipt";
  static String GETBILL_DETAILSLIST = BASE_URL_CORE + "api/Bill/GetAllBill";

  static String GETDROPDOWN_CITYLIST = BASE_URL_CORE + "api/Sales/GetAllCity";
  static String GETDROPDOWN_COMPANYLIST = BASE_URL_CORE + "api/Company/CompanyDropDown";
  static String GETDROPDOWN_GSTLIST = BASE_URL_CORE + "api/Company/GetGstPercentage";
  static String GETDROPDOWN_TDSLIST = BASE_URL_CORE + "api/Company/GetTDSPercentage";
  static String GETSALES_REPORTLIST = BASE_URL_CORE + "api/Reports/GetSalesReport";
  static String GETRECEIPT_REPORTLIST = BASE_URL_CORE + "api/Reports/GetReceiptReport";
  static String GETBILL_REPORTLIST = BASE_URL_CORE + "api/Reports/GetBillReport";

  static String EDITCOMPANY_DETAILSLIST = BASE_URL_CORE + "api/Company/CompanyDetailsGetById";
  static String EDITSALES_DETAILSLIST = BASE_URL_CORE + "api/Sales/SalesDetailsById";
  static String EDITRECEIPT_DETAILSLIST = BASE_URL_CORE + "api/Receipt/ReceiptDetailsById";
  static String EDITBILL_DETAILSLIST = BASE_URL_CORE + "api/Bill/BillDetailsbyId";




  static String EDIT_BILLBOQ_API = BASE_URL_CORE + "api/SubContractorWorkQtyBOQ/GetSubContractorWorkQtyById";



  /// ----- Put API's -----

  static String PUTCOMPANYDETAILS_API = BASE_URL_CORE + "api/Company/updateCompany";
  static String PUTSALESDETAILS_API = BASE_URL_CORE + "api/Sales/UpdateSales";
  static String PUTRECEIPTDETAILS_API = BASE_URL_CORE + "api/Receipt/UpdateReceipt";
  static String PUTBILLDETAILS_API = BASE_URL_CORE + "api/Bill/updateBill";

  /// ----- POST API's -----

  static String COMPANYDETAILS_SAVEAPI = BASE_URL_CORE + "api/Company/AddCompany";
  static String SALESDETAILS_SAVEAPI = BASE_URL_CORE + "api/Sales/AddSales";
  static String RECEIPTDETAILS_SAVEAPI = BASE_URL_CORE + "api/Receipt/AddReceipt";
  static String BILLDETAILS_SAVEAPI = BASE_URL_CORE + "api/Bill/AddBilldetails";


  /// ----- Delete API's -----
  static String COMPANYDETAILS_DELETE = BASE_URL_CORE + "api/Company/DeleteCompanyDetail";
  static String SALESDETAILS_DELETE = BASE_URL_CORE + "api/Sales/DeleteSalesDetails";
  static String RECEIPTDETAILS_DELETE = BASE_URL_CORE + "api/Receipt/DeleteReceiptDetails";
  static String BILLDETAILS_DELETE = BASE_URL_CORE + "api/Bill/DeleteBillDetails";

}

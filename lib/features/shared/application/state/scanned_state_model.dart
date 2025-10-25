import '../../data/models/scanned_details_modal.dart';

class ListOfScannedDataAndResponseMessage {
  final List<ScannedDetailsModal>? listOfScannedData;
  final String responseMessage;

  ListOfScannedDataAndResponseMessage({
    this.listOfScannedData,
    required this.responseMessage,
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/providers/storage_providers.dart';
import '../../../../core/utils/custom_widgets/button_widgets/scan_button_widget.dart';

import '../../../shared/components/component_serialnumber_discription_photo.dart';
import '../../../shared/components/image_upload_module/image_upload_module.dart';
import '../../../shared/components/scanner_module/scanner_module.dart';
import '../../../shared/model/scanned_item_modal.dart';
import '../../../shared/providers/riverpod_provider.dart';
import '../../modal/project_model.dart';
import 'scanned_item_list_widget.dart';

class HomeScreenWidget extends ConsumerStatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreenWidget> {
  final List<ScannedItemModal> scannedList = [];
  final List<ScannedItemModal> addNewScannedData = [];
  final List<TextEditingController> _serialControllers = [];
  final List<TextEditingController> _descriptionControllers = [];
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<List<String>> _descriptionsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _loadScannedData();
  }

  Future<void> _loadScannedData() async {
    // Access the provider using ref
    final databaseHelper = ref.read(databaseHelperProvider);

    final List<Map<String, dynamic>> rawData =
    await databaseHelper.readData('SerialNumberStoreTable');

    final List<ScannedItemModal> allData =
    rawData.map((row) => ScannedItemModal.fromJson(row)).toList();

    setState(() {
      scannedList.clear();
      scannedList.addAll(allData);
    });
  }

  Future<void> _deleteScanned(String serialNumber) async {
    final databaseHelper = ref.read(databaseHelperProvider);

    await databaseHelper.deleteData('SerialNumberStoreTable', serialNumber);
    _loadScannedData();
  }

  @override
  Widget build(BuildContext context) {
    // If you need the databaseHelper in build or other widgets
    final databaseHelper = ref.read(databaseHelperProvider);
    final vendorsAsync = ref.watch(vendorProvider);
    final selectedVendor = ref.watch(selectedVendorProvider);
    final vendorId = selectedVendor?.slno ?? 0;

    final projectsAsync = vendorId != 0
        ? ref.watch(projectProvider(vendorId))
        : const AsyncValue.data(<ProjectModel>[]); // Use empty List<ProjectModel>
    // Empty list when vendor not selected

    final selectedProject = ref.watch(selectedProjectProvider);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Scan and Upload Buttons Row
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Scan QR/Bar
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScannerModule(),
                          ),
                        ).then((_) => _loadScannedData());
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.qr_code, size: 40),
                          SizedBox(height: 8),
                          Text("Scan QR or Bar", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    // Upload Image
                    GestureDetector(
                      onTap: () async {
                        try {
                          final scanResponse = await uploadImageAndScan(ref);

                          if (scanResponse.listOfScannedData != null &&
                              scanResponse.listOfScannedData!.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(scanResponse.responseMessage),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 5),
                              ),
                            );

                            final codeMaps = scanResponse.listOfScannedData!
                                .map((code) => code.toJson())
                                .toList();

                            final dbResponse = await databaseHelper
                                .insertDataList(
                                "SerialNumberStoreTable", codeMaps);
                            _loadScannedData();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(dbResponse),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(scanResponse.responseMessage),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.image_outlined, size: 40),
                          SizedBox(height: 8),
                          Text("Upload Image", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // List of scanned items
              SizedBox(
                height: 540,
                width: double.infinity,
                child: FutureBuilder<List<ScannedItemModal>>(
                  future: Future.value(scannedList),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if ((snapshot.data == null ||
                        snapshot.data!.isEmpty) &&
                        _serialControllers.isEmpty) {
                      return const Center(child: Text("No Scanned Data found"));
                    }

                    final scannedListData = snapshot.data ?? [];

                    // Ensure controller lists include scanned data
                    while (_serialControllers.length < scannedListData.length) {
                      _serialControllers.add(TextEditingController());
                      _descriptionControllers.add(TextEditingController());
                    }

                    // Initialize controllers with scanned data
                    for (int i = 0; i < scannedListData.length; i++) {
                      _serialControllers[i].text = scannedListData[i].serialNumber;
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _serialControllers.length,
                      itemBuilder: (context, index) {
                        final bool isScannedData = index < scannedListData.length;
                        return GenerateComponentSerialDescriptionPhoto(
                          _serialControllers[index],
                          _descriptionControllers[index],
                          index,
                              () async {
                            setState(() {
                              _serialControllers.removeAt(index);
                              _descriptionControllers.removeAt(index);
                            });
                            if (isScannedData) {
                              await _deleteScanned(
                                  scannedListData[index].serialNumber);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),


              // ✅ Scanned Items List
              SizedBox(
                height: 390,
                width: double.infinity,
                child: ScannedItemsList(
                  key: ValueKey(scannedList.length),
                  scannedList: scannedList,
                  onDelete: _deleteScanned,
                  formKey: _formKey,
                  onDescriptionsChanged: (descriptions) {
                    _descriptionsNotifier.value = descriptions;
                  },
                ),
              ),

              // Vendor Dropdown
              vendorsAsync.when(
                data: (list) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GenericDropdownWidget<VendorModel>(
                      title: 'Vendor',
                      items: list,
                      selectedItem: selectedVendor,
                      displayText: (v) => v.vendorName,
                      hint: 'Choose a vendor',
                      prefixIcon: Icons.business,
                      onChanged: (value) {
                        ref.read(selectedVendorProvider.notifier).state = value;
                      },
                    ),
                  );
                },
                loading: () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GenericDropdownWidget<VendorModel>(
                    title: 'Vendor',
                    items: const [],
                    selectedItem: null,
                    displayText: (v) => v.vendorName,
                    hint: 'Choose a vendor',
                    prefixIcon: Icons.business,
                    isLoading: true, // ✅ This shows the loading indicator
                    onChanged: (value)
                    {
                      setState(() {

                      });
                      ref.read(selectedVendorProvider.notifier).state = value;
                      ref.read(selectedProjectProvider.notifier).state = null;
                    },
                  ),
                ),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GenericDropdownWidget<VendorModel>(
                    title: 'Vendor',
                    items: const [],
                    selectedItem: null,
                    displayText: (v) => v.vendorName,
                    hint: 'Choose a vendor',
                    prefixIcon: Icons.business,
                    errorMessage:
                    'Failed to load vendors', // ✅ This shows the error
                    onChanged: (value) {

                    },
                  ),
                ),
              ),

              // Project Dropdown
              projectsAsync.when(
                data: (list) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GenericDropdownWidget<ProjectModel>(
                      title: 'Project',
                      items: list,
                      selectedItem: selectedProject,
                      displayText: (p) => p.projectName,
                      hint: 'Choose a project',
                      prefixIcon: Icons.folder,
                      onChanged: (value) {
                        ref.read(selectedProjectProvider.notifier).state =
                            value;
                      },
                    ),
                  );
                },
                loading: () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GenericDropdownWidget<ProjectModel>(
                    title: 'Project',
                    items: const [],
                    selectedItem: null,
                    displayText: (p) => p.projectName,
                    hint: 'Choose a project',
                    prefixIcon: Icons.folder,
                    isLoading: true, // ✅ This shows the loading indicator
                    onChanged: (value) {},
                  ),
                ),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GenericDropdownWidget<ProjectModel>(
                    title: 'Project',
                    items: const [],
                    selectedItem: null,
                    displayText: (p) => p.projectName,
                    hint: 'Choose a project',
                    prefixIcon: Icons.folder,
                    errorMessage:
                    'Failed to load projects', // ✅ This shows the error
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Store Data Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ScanButtonWidget(
                    text: "Store Data",
                    onPressed: () async {
                      // Your existing store logic
                      // Make sure to access databaseHelper via ref.read(databaseHelperProvider)
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget GenerateComponentSerialDescriptionPhoto(
    TextEditingController _controllerSerialNumber,
    TextEditingController _controllerDescription,
    int index,
    void Function()? onDelete) {
  return ComponentSerialnumberDiscriptionPhoto(
    showDelete: index != -1,
    onDelete: onDelete,
    serialController: _controllerSerialNumber,
    descriptionController: _controllerDescription,
    serialValidator: (index) => _controllerSerialNumber.text.trim().isEmpty
        ? 'Serial number cannot be empty'
        : null,
    descriptionValidator: (index) => _controllerDescription.text.trim().isEmpty
        ? 'Description cannot be empty'
        : null,
  );
}


// ✅ Separate StatefulWidget for Scanned Items List
class ScannedItemsList extends StatefulWidget {
  final List<ScannedItemModal> scannedList;
  final Function(String) onDelete;
  final GlobalKey<FormState> formKey;
  final Function(List<String>)? onDescriptionsChanged;

  const ScannedItemsList({
    Key? key,
    required this.scannedList,
    required this.onDelete,
    required this.formKey,
    this.onDescriptionsChanged,
  }) : super(key: key);

  @override
  State<ScannedItemsList> createState() => _ScannedItemsListState();
}




class _ScannedItemsListState extends State<ScannedItemsList> {
  final List<TextEditingController> _serialControllers = [];
  final List<TextEditingController> _descriptionControllers = [];
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(ScannedItemsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scannedList.length != oldWidget.scannedList.length) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    // Dispose old controllers
    if (_controllersInitialized) {
      for (var controller in _serialControllers) {
        controller.dispose();
      }
      for (var controller in _descriptionControllers) {
        controller.removeListener(_notifyDescriptionsChanged);
        controller.dispose();
      }
    }

    _serialControllers.clear();
    _descriptionControllers.clear();

    // Create new controllers
    for (var item in widget.scannedList) {
      _serialControllers.add(TextEditingController(text: item.serialNumber));

      final descController = TextEditingController();
      descController.addListener(_notifyDescriptionsChanged);
      _descriptionControllers.add(descController);
    }

    _controllersInitialized = true;
    _notifyDescriptionsChanged(); // Initial notification
  }

  // ✅ Notify parent when descriptions change
  void _notifyDescriptionsChanged() {
    if (widget.onDescriptionsChanged != null) {
      final descriptions = _descriptionControllers
          .map((controller) => controller.text.trim())
          .toList();
      widget.onDescriptionsChanged!(descriptions);
    }
  }

  @override
  void dispose() {
    for (var controller in _serialControllers) {
      controller.dispose();
    }
    for (var controller in _descriptionControllers) {
      controller.removeListener(_notifyDescriptionsChanged);
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleDelete(int index) async {
    if (index < widget.scannedList.length) {
      await widget.onDelete(widget.scannedList[index].serialNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scannedList.isEmpty && _serialControllers.isEmpty) {
      return const Center(child: Text("No Scanned Data found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _serialControllers.length,
      itemBuilder: (context, index) {
        final bool isScannedData = index < widget.scannedList.length;
        return GenerateComponentSerialDescriptionPhoto(
          _serialControllers[index],
          _descriptionControllers[index],
          index,
              () async {
            if (isScannedData) {
              await _handleDelete(index);
            }
          },
        );
      },
    );
  }
}
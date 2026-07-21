import 'package:flutter/material.dart';
import 'package:newklikrkw/models/dkasbon.dart';
import 'package:newklikrkw/services/kasbon_service.dart';
import 'package:newklikrkw/utils/utils.dart';

class DkasbonListWidget extends StatefulWidget {
  final String kasbonId;
  final String randomCode;
  const DkasbonListWidget({
    super.key,
    required this.kasbonId,
    required this.randomCode,
  });

  @override
  State<DkasbonListWidget> createState() => _DkasbonListWidgetState();
}

class _DkasbonListWidgetState extends State<DkasbonListWidget> {
  final ScrollController _scrollController = ScrollController();

  final KasbonService _service = KasbonService();

  final List<Dkasbon> _items = [];

  int _page = 1;

  bool _isLoading = false;
  bool _hasMore = true;
  @override
  void initState() {
    _loadData();
    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DkasbonListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if specific data passed from the parent changed
    if (widget.randomCode != oldWidget.randomCode) {
      _refresh();
    }
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _service.getDKasbons(
        kasbonId: widget.kasbonId,
        page: _page,
      );

      final List<Dkasbon> newData = List<Dkasbon>.from(result['data']);

      setState(() {
        _items.addAll(newData);

        _hasMore = result['hasMore'];

        if (newData.isNotEmpty) {
          _page++;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 1;
      _hasMore = true;
    });

    await _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildItem(Dkasbon item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                CommonUtils.truncate(item.itemkegiatan!.namaItemkegiatan, 20),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CommonUtils.formatDate(
                      item.updatedAt,
                      format: 'dd-MMM-yy HH:mm ',
                    ),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Pemohon : ${item.transpermohonan!.namaPenerima} ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Obyek : ${item.transpermohonan!.alasHak} ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Letak : ${item.transpermohonan!.letakObyek} ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    '${item.ketBiaya} ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              trailing: Text('Rp ${item.jumlahBiaya.toStringAsFixed(0)}'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _items.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _items.length) {
            return _buildItem(_items[index]);
          }

          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

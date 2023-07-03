import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

// Lớp _AzItems dùng để đại diện cho một mục trong danh sách cuộn
class _AzItems extends ISuspensionBean {
  final String title; // Tiêu đề của mục
  final String tag; // Tag để nhóm các mục theo chữ cái

  _AzItems({required this.title, required this.tag});

  @override
  String getSuspensionTag() => tag; // Trả về tag của mục
}

class AlphabetScrollPage extends StatefulWidget {
  final List<String> items; // Danh sách các mục
  final ValueChanged<String> onClickedItem; // Callback khi một mục được nhấp

  const AlphabetScrollPage({
    Key? key,
    required this.items,
    required this.onClickedItem,
  }) : super(key: key);

  @override
  State<AlphabetScrollPage> createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  List<_AzItems> items = [];

  @override
  void initState() {
    super.initState();
    initList(widget.items); // Khởi tạo danh sách các mục từ danh sách đầu vào
  }

  @override
  Widget build(BuildContext context) => AzListView(
    padding: const EdgeInsets.all(16),
    data: items, // Dữ liệu cho danh sách cuộn
    itemCount: items.length, // Số lượng mục trong danh sách
    itemBuilder: (context, index) {
      final item = items[index];
      return _buildItems(item); // Xây dựng widget cho mục trong danh sách
    },
    indexBarOptions: const IndexBarOptions(
      needRebuild: true,
      indexHintAlignment: Alignment.centerRight,
      indexHintOffset: Offset(-20, 0),
      selectTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      selectItemDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    ),
    indexBarMargin: const EdgeInsets.all(10),
    indexHintBuilder: (context, hint) => Container(
      alignment: Alignment.center,
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Text(
        hint,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );

  // Khởi tạo danh sách các mục từ danh sách đầu vào
  void initList(List<String> items) {
    this.items = items
        .map((item) => _AzItems(title: item, tag: item[0].toUpperCase()))
        .toList();
    SuspensionUtil.sortListBySuspensionTag(this.items); // Sắp xếp danh sách theo tag
    SuspensionUtil.setShowSuspensionStatus(this.items); // Đặt trạng thái hiển thị cho các nhóm
  }

  // Xây dựng widget cho một mục trong danh sách
  Widget _buildItems(_AzItems item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(
      children: [
        Offstage(offstage: offstage, child: buildHeader(tag)), // Hiển thị header nếu cần
        Container(
          padding:const EdgeInsets.only(right: 16),
          margin: const EdgeInsets.only(right: 16),
          child: ListTile(
            title: Text(item.title), // Hiển thị tiêu đề của mục
            onTap: () => widget.onClickedItem(item.title), // Xử lý sự kiện khi mục được nhấp
          ),
        ),
      ],
    );
  }

  // Xây dựng widget cho header
  Widget buildHeader(String tag) => Container(
    height: 40,
    alignment: Alignment.bottomLeft,
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(8),
    color: Colors.grey.shade300,
    child: Text(
      tag,
      softWrap: false,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

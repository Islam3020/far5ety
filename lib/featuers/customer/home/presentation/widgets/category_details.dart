import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/featuers/customer/home/presentation/widgets/show_details_dialog.dart';


class CategoryDetailsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailsScreen({super.key, required this.categoryName});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
 

  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    super.initState();
    AppLocalStorage.cacheData(key: AppLocalStorage.userToken, value: userId);
    fetchProducts(widget.categoryName);
  }

  Future<void> fetchProducts(String categoryName) async {
    try {
      // استبدل هذا الجزء بكود جلب البيانات من قاعدة البيانات الخاصة بك
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productType', isEqualTo: categoryName)
          .get();

      setState(() {
        items = snapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
      setState(() => isLoading = false);
    }
   
       
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل ${widget.categoryName}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => showDetailsDialog(
                      context: context,
                      
                      productName: item['productName'] ?? '',
                      price: "${item['productPrice']}" ,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Text(
                            item['productName'] ?? '',
                            style: getTitleStyle(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${item['productPrice']} ج.م',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
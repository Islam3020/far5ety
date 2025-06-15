import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/utils/colors.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/featuers/customer/home/presentation/widgets/category_details.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [];
  bool isLoading = true;
 User? user;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }
  @override
  void initState() {
    super.initState();
    AppLocalStorage.cacheData(
      key: AppLocalStorage.userType,
      value: 'user',
    );
    
    _getUser(); 
    getProductTypes();
  }

 Future<void> getProductTypes() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    // استخراج أنواع المنتجات مع إزالة التكرارات
    final types = snapshot.docs
        .map((doc) => doc['productType'] as String? ?? '') // استخراج حقل productType
        .where((type) => type.isNotEmpty) // استبعاد القيم الفارغة
        .toSet() // إزالة التكرارات
        .toList(); // تحويل إلى قائمة

    setState(() {
      categories = types; // تخزين الأنواع في المتغير
      isLoading = false;
    });
    
    debugPrint('Fetched types: $types'); // طباعة الأنواع للتأكد
  } catch (e) {
    debugPrint('Error fetching product types: $e');
    setState(() => isLoading = false);
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختار القسم'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : categories.isEmpty
              ? Center(child: Text('لا يوجد منتجات', style: getBodyStyle()))
            : ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                     push(context, CategoryDetailsScreen(categoryName:category ,));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 10.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          
                          Expanded(
                            child: Text(
                              category,
                              style: getTitleStyle(color: AppColors.black),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 20.sp, color: AppColors.greyColor),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      backgroundColor:AppColors.accentColor
      // const Color(0xFFF5F5F5),
    );
  }
}

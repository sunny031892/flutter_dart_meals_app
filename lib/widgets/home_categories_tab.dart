import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lab08/data/dummy_data.dart';
import 'package:lab08/models/category.dart';
import 'package:lab08/services/navigation.dart';
import 'package:lab08/widgets/category_grid_item.dart';

class HomeCategoriesTab extends StatefulWidget {
  const HomeCategoriesTab({super.key});

  @override
  State<HomeCategoriesTab> createState() => _HomeCategoriesTabState();
}

class _HomeCategoriesTabState extends State<HomeCategoriesTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<Animation<Offset>> _animations = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final rows = (dummyCategories.length / 2).ceil();
    final intervalDuration = 1 / rows;

    _animations = List.generate(
      dummyCategories.length,
      (index) => Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index ~/ 2) * intervalDuration,
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goMealsOnCategory(categoryId: category.id);
  }

  @override
  Widget build(BuildContext context) {
    final categories = dummyCategories.values.toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) => SlideTransition(
        position: _animations[index],
        child: CategoryGridItem(
          category: categories[index],
          onSelectCategory: () {
            _selectCategory(context, categories[index]);
          },
        ),
      ),
    );
  }
}

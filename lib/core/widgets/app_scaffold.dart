import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.resizeToAvoidBottomInset = true,
    this.safeArea = true,
    this.loading = false,
    this.centerTitle = true,
    this.appBar,
  });

  final Widget body;

  final PreferredSizeWidget? appBar;

  final String? title;

  final List<Widget>? actions;

  final Widget? leading;

  final Widget? floatingActionButton;

  final Widget? bottomNavigationBar;

  final Widget? drawer;

  final Color? backgroundColor;

  final EdgeInsetsGeometry padding;

  final bool resizeToAvoidBottomInset;

  final bool safeArea;

  final bool loading;

  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: body);

    if (safeArea) {
      content = SafeArea(child: content);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            drawer: drawer,
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
            appBar:
                appBar ??
                (title == null
                    ? null
                    : AppBar(
                        title: Text(title!),
                        centerTitle: centerTitle,
                        leading: leading,
                        actions: actions,
                      )),
            body: content,
          ),

          if (loading)
            ColoredBox(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

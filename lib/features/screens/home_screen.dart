import 'package:flutter/material.dart';
import 'package:dalil/generated/l10n.dart';
import 'package:dalil/core/services/firestore_service.dart';

import '../../core/widget/home_header.dart';
import '../../core/widget/home_search_field.dart';
import '../../core/widget/home_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService service = FirestoreService();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  String _searchQuery = "";

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = "";
      }
    });
  }

  void _submitSearch(String value) {
    setState(() => _searchQuery = value.trim());
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _searchQuery = "";
      _searchController.clear();
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E2D),
        elevation: 0,
        title: Text(
          loc.dalil,
          style: const TextStyle(color: Color(0xFFE5C158), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: HomeSearchField(
                  controller: _searchController,
                  hintText: loc.seeMore,
                  onSubmitted: _submitSearch,
                ),
              )
            : null,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/pyram.png'), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.6),
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              color: const Color(0xFFE5C158),
              onRefresh: _onRefresh,
              child: ListView(
                children: [
                  SizedBox(height: width * 0.05),
                  if (_searchQuery.isEmpty) const HomeHeader(),

                  HomeSection(
                    title: loc.attractions,
                    icon: Icons.account_balance,
                    collection: "attractions",
                    stream: service.getPlaces("attractions"),
                    lang: lang,
                    searchQuery: _searchQuery,
                  ),

                  HomeSection(
                    title: loc.kings,
                    icon: Icons.workspace_premium,
                    collection: "kings",
                    stream: service.getPlaces("kings"),
                    lang: lang,
                    searchQuery: _searchQuery,
                  ),

                  HomeSection(
                    title: loc.eras,
                    icon: Icons.history,
                    collection: "eras",
                    stream: service.getPlaces("eras"),
                    lang: lang,
                    searchQuery: _searchQuery,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
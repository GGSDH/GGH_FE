import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isTyping = false;
  bool _showResults = false;
  bool _hasResults = true;

  void onChanged(String value) {
    setState(() {
      _isTyping = value.isNotEmpty;
      _showResults = false;
    });
  }

  void onSubmitted(String value) {
    setState(() {
      _isTyping = false;
      _showResults = value.isNotEmpty;
      _hasResults = value.isNotEmpty;
    });
  }

  void clearSearch() {
    setState(() {
      _searchController.clear();
      _isTyping = false;
      _showResults = false;
      _hasResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_chevron_left.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SearchBar(
                        controller: _searchController,
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                        showCloseButton: _showResults,
                        onClearSearch: clearSearch,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_searchController.text.isEmpty && !_isTyping)
                        PopularSearchTerms(),
                      if (_isTyping) const TypingIndicator(),
                      if (_showResults && _hasResults)
                        SearchResults(searchTerm: _searchController.text),
                      if (_showResults && !_hasResults) const NoSearchResults(),
                    ],
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

class NoSearchResults extends StatelessWidget {
  const NoSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        SvgPicture.asset(
          "assets/icons/ic_search_typing.svg",
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 14),
        Text(
          "검색 결과가 없습니다.",
          style: TextStyles.titleLarge.copyWith(
            color: ColorStyles.gray800,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final bool showCloseButton;
  final VoidCallback onClearSearch;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.showCloseButton,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorStyles.gray200),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/ic_search.svg",
            width: 20,
            height: 20,
            colorFilter:
                const ColorFilter.mode(ColorStyles.gray400, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyles.bodyMedium,
              onChanged: onChanged,
              onFieldSubmitted: onSubmitted,
              decoration: const InputDecoration(
                hintText: "검색어를 입력해주세요",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (showCloseButton)
            GestureDetector(
              onTap: onClearSearch,
              child: SvgPicture.asset(
                'assets/icons/ic_close_textfield.svg',
                width: 20,
                height: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class PopularSearchTerms extends StatelessWidget {
  PopularSearchTerms({super.key});

  final List<String> popularKeywords = [
    "경기도",
    "버스",
    "지하철",
    "택시",
    "공항버스",
    "경기도 관광",
    "경기도 축제",
    "경기도 맛집",
    "경기도 박물관",
    "경기도 놀이공원"
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final updateTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "지금,",
                        style: TextStyles.headlineXSmall,
                      ),
                      Text(
                        "인기 검색어",
                        style: TextStyles.headlineXSmall
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
              Text("오늘 $updateTime 기준", style: TextStyles.bodyXSmall),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: popularKeywords.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      "${index + 1}",
                      style: TextStyles.titleLarge.copyWith(
                        color: ColorStyles.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    popularKeywords[index],
                    style: TextStyles.bodyLarge.copyWith(
                        color: ColorStyles.gray900,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        SvgPicture.asset(
          "assets/icons/ic_search_typing.svg",
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 14),
        Text(
          "검색어를 입력 중입니다...",
          style: TextStyles.titleLarge.copyWith(
              color: ColorStyles.gray800, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class SearchResults extends StatelessWidget {
  final String searchTerm;

  SearchResults({super.key, required this.searchTerm});

  final List<Map<String, String>> results = [
    {
      "title": "너랑나랑",
      "subtitle": "관광명소 ∙ 서울 종로구",
    },
    {
      "title": "서울 테마파크",
      "subtitle": "관광명소 ∙ 서울 종로구",
    },
    {
      "title": "경복궁",
      "subtitle": "역사유적 ∙ 서울 종로구",
    },
    {
      "title": "남산서울타워",
      "subtitle": "랜드마크 ∙ 서울 용산구",
    },
    {
      "title": "북촌한옥마을",
      "subtitle": "전통마을 ∙ 서울 종로구",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorStyles.gray100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/ic_map_pin.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          results[index]["title"]!,
                          style: TextStyles.titleMedium
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          results[index]["subtitle"]!,
                          style: TextStyles.bodySmall
                              .copyWith(color: ColorStyles.gray600),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

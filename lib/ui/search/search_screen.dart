import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gyeonggi_express/data/models/response/keyword_search_result_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_keyword_response.dart';
import 'package:gyeonggi_express/themes/color_styles.dart';
import 'package:gyeonggi_express/themes/text_styles.dart';
import 'package:gyeonggi_express/ui/search/search_bloc.dart';

import '../../data/repository/search_repository.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(GetIt.instance<SearchRepository>())
        ..add(FetchPopularKeywords()),
      child: const SearchScreenContent(),
    );
  }
}

class SearchScreenContent extends StatefulWidget {
  const SearchScreenContent({super.key});

  @override
  _SearchScreenContentState createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // 키보드가 올라올 때 화면 크기 조정 방지
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
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            context
                                .read<SearchBloc>()
                                .add(PerformSearch(value));
                          }
                        },
                        onClearSearch: () {
                          _searchController.clear();
                          context
                              .read<SearchBloc>()
                              .add(FetchPopularKeywords());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  // 스크롤 가능하게 만듦
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PopularKeywordsLoaded) {
                        return PopularSearchTerms(
                          keywords: state.keywords,
                          onKeywordTap: (keyword) {
                            _searchController.text = keyword;
                            context
                                .read<SearchBloc>()
                                .add(PerformSearch(keyword));
                          },
                        );
                      } else if (state is SearchResultsLoaded) {
                        return SearchResults(results: state.results);
                      } else if (state is SearchError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const SizedBox.shrink();
                      }
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

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final VoidCallback onClearSearch;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onClearSearch,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scrollable.ensureVisible(context,
              alignment: 0.0, duration: const Duration(milliseconds: 300));
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
              controller: widget.controller,
              focusNode: _focusNode,
              style: TextStyles.bodyMedium,
              onFieldSubmitted: widget.onSubmitted,
              decoration: const InputDecoration(
                hintText: "검색어를 입력해주세요",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onClearSearch,
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
  final List<PopularKeyword> keywords;
  final Function(String) onKeywordTap;

  const PopularSearchTerms({
    super.key,
    required this.keywords,
    required this.onKeywordTap,
  });

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
                  ],
                ),
              ),
              Text("오늘 $updateTime 기준", style: TextStyles.bodyXSmall),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: keywords.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => onKeywordTap(keywords[index].keyword),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
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
                      keywords[index].keyword,
                      style: TextStyles.bodyLarge.copyWith(
                        color: ColorStyles.gray900,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SearchResults extends StatelessWidget {
  final List<KeywordSearchResult> results;

  const SearchResults({super.key, required this.results});

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
              final result = results[index];
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
                          result.name,
                          style: TextStyles.titleMedium
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${result.tripThemeConstants} · ${result.sigunguCode}",
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

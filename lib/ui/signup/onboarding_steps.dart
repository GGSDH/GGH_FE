import 'package:gyeonggi_express/ui/signup/component/select_grid.dart';

final List<Map<String, dynamic>> signupSteps = [
  {
    'question': '어떤 여행 테마를 선호하시나요?',
    'description': '여행 테마를 선택해 주세요 (최대 3개)',
    'maxSelections': 3,
    'items': [
      SelectableGridItemData(id: '1', emoji: '🏃', title: '체험/액티비티'),
      SelectableGridItemData(id: '2', emoji: '📸', title: 'SNS 핫플'),
      SelectableGridItemData(id: '3', emoji: '🌳', title: '푸른 자연'),
      SelectableGridItemData(id: '4', emoji: '🏛️', title: '유명 관광지'),
      SelectableGridItemData(id: '5', emoji: '🍽️', title: '지역 특색'),
      SelectableGridItemData(id: '6', emoji: '🎭', title: '문화/예술/역사'),
      SelectableGridItemData(id: '7', emoji: '🍳', title: '맛집 탐방'),
      SelectableGridItemData(id: '8', emoji: '😌', title: '힐링'),
    ],
  },
  {
    'question': '선호하는 여행 기간은 어떻게 되시나요?',
    'description': '가장 선호하는 여행 기간을 선택해 주세요',
    'maxSelections': 1,
    'items': [
      SelectableGridItemData(id: '1', emoji: '🌞', title: '당일치기'),
      SelectableGridItemData(id: '2', emoji: '🌙', title: '1박 2일'),
      SelectableGridItemData(id: '3', emoji: '🌄', title: '2박 3일'),
      SelectableGridItemData(id: '4', emoji: '✈️', title: '3박 이상'),
    ],
  },
  {
    'question': '주로 누구와 함께 여행하시나요?',
    'description': '가장 자주 떠나는 여행 동반자를 선택해 주세요',
    'maxSelections': 1,
    'items': [
      SelectableGridItemData(id: '1', emoji: '🧍', title: '혼자'),
      SelectableGridItemData(id: '2', emoji: '💑', title: '연인과'),
      SelectableGridItemData(id: '3', emoji: '👨‍👩‍👧‍👦', title: '가족과'),
      SelectableGridItemData(id: '4', emoji: '👥', title: '친구들과'),
      SelectableGridItemData(id: '5', emoji: '🐾', title: '반려동물과'),
    ],
  },
  {
    'question': '여행 시 가장 중요하게 생각하는 것은 무엇인가요?',
    'description': '여행의 우선순위를 선택해 주세요 (최대 2개)',
    'maxSelections': 2,
    'items': [
      SelectableGridItemData(id: '1', emoji: '💰', title: '비용'),
      SelectableGridItemData(id: '2', emoji: '⭐', title: '편의성'),
      SelectableGridItemData(id: '3', emoji: '📷', title: '인생샷'),
      SelectableGridItemData(id: '4', emoji: '🍽️', title: '맛있는 음식'),
      SelectableGridItemData(id: '5', emoji: '🆕', title: '새로운 경험'),
      SelectableGridItemData(id: '6', emoji: '🎭', title: '다양한 활동'),
    ],
  },
  {
    'question': '선호하는 교통수단은 무엇인가요?',
    'description': '여행 시 주로 이용하는 교통수단을 선택해 주세요',
    'maxSelections': 1,
    'items': [
      SelectableGridItemData(id: '1', emoji: '🚗', title: '자가용'),
      SelectableGridItemData(id: '2', emoji: '🚄', title: '기차'),
      SelectableGridItemData(id: '3', emoji: '🚌', title: '버스'),
      SelectableGridItemData(id: '4', emoji: '🚲', title: '자전거'),
      SelectableGridItemData(id: '5', emoji: '🚶', title: '도보'),
    ],
  }
];

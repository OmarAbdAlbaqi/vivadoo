import 'package:flutter/material.dart';

class HtmlTextView extends StatelessWidget {
  final String htmlText;
  final double lineSpacing;
  final int? maxLines;

  const HtmlTextView({super.key, required this.htmlText, this.lineSpacing = 8.0, this.maxLines});

  @override
  Widget build(BuildContext context) {
    final parsedWidgets = HtmlParser(htmlText, lineSpacing).parse();
    final itemCount = maxLines == null ?  1 : parsedWidgets.length > maxLines! ? maxLines : parsedWidgets.length;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: lineSpacing),
          child: parsedWidgets[index],
        );
      },
    );
  }
}






class HtmlParser {
  final String htmlText;
  final double lineSpacing;
  final int maxLines;

  HtmlParser(this.htmlText, this.lineSpacing, {this.maxLines = 5});

  List<Widget> parse() {
    final elements = _splitHtmlTags(htmlText.trim()); // Trim the HTML text
    return elements.map((element) {
      if (element.isNotEmpty) {
        print("element = $element");
        return Text(
          _decodeHtmlString(element),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            height: 0.01, // Adjust line height here (1.0 = normal line height)
          ),
        );
      } else {
        return const SizedBox.shrink(); // Skip empty elements
      }
    }).toList();
  }

  List<String> _splitHtmlTags(String htmlString) {
    // Split HTML tags and content
    return htmlString.split(RegExp(r'(&bull;|<br\s*/*>|\s*<[^>]*>\s*)'));
    // Adjusted regular expression to exclude whitespace between tags
  }

  String _decodeHtmlString(String htmlString) {
    // Remove leading and trailing whitespace
    htmlString = htmlString.trim();
    // Remove any remaining HTML tags
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }
}





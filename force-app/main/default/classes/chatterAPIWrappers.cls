public with sharing class chatterAPIWrappers {

    public static ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
    public static ConnectApi.MarkupEndSegmentInput markupEndSegment;
    public static ConnectApi.TextSegmentInput textSegment;


    public static List<ConnectApi.MessageSegmentInput> newLine() {
        List<ConnectApi.MessageSegmentInput> output = new  List<ConnectApi.MessageSegmentInput>();

        markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
        output.add(markupBeginSegment);

        textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = '&nbsp;';
        output.add(textSegment);

        markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
        output.add(markupEndSegment);

        return output;
    }

    public static List<ConnectApi.MessageSegmentInput> makeBoldParagraph(string text) {
        List<ConnectApi.MessageSegmentInput> output = new  List<ConnectApi.MessageSegmentInput>();

        markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
        output.add(markupBeginSegment);

        markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = ConnectApi.MarkupType.Bold;
        output.add(markupBeginSegment);

        textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = text;
        output.add(textSegment);

        markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = ConnectApi.MarkupType.Bold;
        output.add(markupEndSegment);

        markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
        output.add(markupEndSegment);

        return output;
    }

    public static List<ConnectApi.MessageSegmentInput> makeParagraph(string text) {
        List<ConnectApi.MessageSegmentInput> output = new  List<ConnectApi.MessageSegmentInput>();

        markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
        output.add(markupBeginSegment);

        textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = text;
        output.add(textSegment);

        markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
        output.add(markupEndSegment);

        return output;

    }
}

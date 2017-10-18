trigger fieldInspection on Field_Inspection__c (after update) {

    list<Field_Inspection__c> FIs = [select id, createdById, Dealer__r.Name, Display_Quality__c, Guidelines_Brand_Display__c, Guidelines_Data_Quality__c, Guidelines_Lead__c, Merchandise_Mix__c, Model_Selection__c, Dealer__c, Square_Feet_per_Bike__c from Field_Inspection__c where id in: trigger.new];

    for (Field_Inspection__c fi:FIs){

        //skip all this for incomplete surveys just initiated
        if (fi.Square_Feet_per_Bike__c == null){
            continue;
        }

        //skip if there's already a post
        list<feeditem> existingPosts = [select id from feeditem where parentId =: fi.Id];
        if (!existingPosts.isEmpty()){
            continue;
        }

        //get the contact/user for this account
        list<user> dealerUsers = [select id from user where contact.accountId =: fi.Dealer__c limit 1];

        //get the recommended trainings
        list<Recommended_Training__c> RTs = [select id, name from Recommended_Training__c where Field_Inspection__c =: fi.Id];

        //get the community by name
        list<Network> Communities = [select Id from Network where Name='Dealer Managers'];

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.subjectId = fi.Id; //post should be on the inspection itself
        input.feedElementType = ConnectApi.FeedElementType.FeedItem;

        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        ConnectApi.TextSegmentInput textSegment;
        ConnectApi.MentionSegmentInput mentionSegment;
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
        ConnectApi.MarkupEndSegmentInput markupEndSegment;

        //mention the dealer
        if (!dealerUsers.isEmpty()){
            mentionSegment = new ConnectApi.MentionSegmentInput();
            mentionSegment.id = dealerUsers[0].Id;
            messageInput.messageSegments.add(mentionSegment);
        }

        //mention the evaluator
        mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = fi.createdById;
        messageInput.messageSegments.add(mentionSegment);

        messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Congrats! '+ fi.Dealer__r.Name +' Passed the Dealer Assessment!'));

        messageInput.messageSegments.addAll(chatterAPIWrappers.makeBoldParagraph('Retail Identity: Keep up!'));
        messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Sq ft per bike: ' + fi.Square_Feet_per_Bike__c));
        messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Bike model selection: ' + fi.Model_Selection__c));
        messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Merchandise mix: ' + fi.Merchandise_Mix__c));
        messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Display quality: ' + fi.Display_Quality__c));


        messageInput.messageSegments.addAll(chatterAPIWrappers.newLine());

        integer GLCounter = 0;
        if (fi.Guidelines_Brand_Display__c){
            GLCounter++;
        }
        if (fi.Guidelines_Data_Quality__c){
            GLCounter++;
        }
        if (fi.Guidelines_Lead__c){
            GLCounter++;
        }

        messageInput.messageSegments.addAll(chatterAPIWrappers.makeBoldParagraph('Guidelines Shared: ' + string.valueOf(GLCounter)));
        if (fi.Guidelines_Brand_Display__c){
            messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Brand Display'));
        }
        if (fi.Guidelines_Data_Quality__c){
            messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Data Quality'));
        }
        if (fi.Guidelines_Lead__c){
            messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph('Lead Follow-up'));
        }

        messageInput.messageSegments.addAll(chatterAPIWrappers.newLine());

        messageInput.messageSegments.addAll(chatterAPIWrappers.makeBoldParagraph('Training to Complete: ' + string.valueOf( RTs.size() )));
        for (Recommended_Training__c RT:RTS){
            messageInput.messageSegments.addAll(chatterAPIWrappers.makeParagraph(RT.Name));
        }
        input.body = messageInput;

        if (Communities.isEmpty()){
            ConnectApi.ChatterFeeds.postFeedElement(null, input);
        } else {
            ConnectApi.ChatterFeeds.postFeedElement(Communities[0].Id, input);
        }

    }
}

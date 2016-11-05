class user_input {

  int insertedWordCounter = 0; //keeps track of element user is inputing
  char firstLetter = ' ';
  String questionString = "Abdul please answer this question";   
  String userInput = ""; //array for input by the user 
  PImage[] cards = new PImage[52];
  int nextCall;
  int callOnce = 0; // get voice called once

  BufferedReader reader;
  String line;
  int stopLoop = 0;
  HashMap<String, Integer> cardToNum = new HashMap<String, Integer>();

  void user_input()
  {
        
    
  }

  int ask() {
    nextCall = 1;
    if (key == ENTER) {
      nextCall = 2;
      println();
      key = ' ';//to remove key from having enter stored
      return nextCall;
    }

    if (insertedWordCounter == 0) {
      firstLetter = key; //checks first letter entered
    }

    //if its only first letter it wont store it in the array
    switch (firstLetter) {
    case '/':  //if first letter is / store whats being typed but display something else, this way they dont see you typign th answer
      if (insertedWordCounter < questionString.length())//display up until the end of string
      {
        print(questionString.charAt(insertedWordCounter));
      } else {
        print(key);
      } //print whats being written rather from string once end of string is reached, to avoid outofbound error

      if (key == '.') { 
        firstLetter = '.'; 
        break;
      }
      if (insertedWordCounter !=0)userInput += key; //insert what the user is actually inputting 

      break;
    case '.':    //user entering question will press . to note that they are done writing the answer and rest characters shoulndt be recorded

      print(questionString.charAt(insertedWordCounter)); //will print the rest of the string from where the user pressed '.'
      firstLetter = '.';

      break;
    case ',':

    default:  //if user did not click the secret key then just print out whats being entered and stored that 
      print(key);
      userInput += key;
    }

    insertedWordCounter+=1; 

    return nextCall;
  }//endfunction
  
    int question() {
    if (callOnce == 0) {
      speech("what is your question ?"); 
      callOnce++;
    } //need this to be displayed only once
    print(key);
    if (key == ENTER) {
      nextCall = 4 ;
      callOnce = 0; //to enter that loop again if another question is asked
    }
    return nextCall;
  }

  //displays the answer
  int answer() {
 
      displayCard();
    if (cardToNum.containsKey(userInput)) {

      image(cards[cardToNum.get(userInput)], 25, 25, cards[1].width/2, cards[1].height/2);
    } else speech(userInput);
    insertedWordCounter = 0;
    userInput = "";
    return nextCall = 0;
  }


  void speech(String text) {
    try {
      Runtime.getRuntime().exec(new String[] {"say", "-v", "Victoria", "[[rate " + Integer.toString(200) + "]]" + text});
    }
    catch (IOException e) {
      //do nothing
    }
  }
  
  void displayCard(){
    for ( int i = 0; i< 52; i++ )
    {
      cards[i] = loadImage( i + ".png" );
    }

    reader = createReader("cards.tab");    //opens the file
    while (stopLoop == 0)
    {
      try {
        line = reader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      if (line == null) {
        // Stop reading because of an error or file is empty
        stopLoop = 1;
      } else {
        String[] pieces = split(line, TAB);
        cardToNum.put(pieces[0], parseInt(pieces[1]));
      }
    }
  }
}//end class
// In Nomine character generator
// Dart 1.22.1

//
// Imports
//
import 'dart:math';
import 'dart:mirrors';

//
// Initialize global variables
//

Map types = {
              "angel":{
                "cb":["Seraph","Cherub","Ofanite","Elohite","Malakite","Kyriotate","Mercurian"],
                "words":["Dreams","Children","Stone","Judgment","Creation","Fire","the Wind","Lightning","Animals","Faith","the Sword","Revelation","Trade","War","Flowers","Destiny","Protection"]
              }, "demon":{
                "cb":["Balseraph","Djinn","Calabite","Habbalite","Lilim","Shedite","Impudite"],
                "words":["Nightmares","Lust","the Game","the War","Fire","Drugs","Hardcore","Secrets (shhh!)","Gluttony","Dark Humor","Fate","Freedom","Factions","the Media","Death","Theft","Technology"]
              }
            };

//
// Global functions
//

// Returns a random element from the supplied array
List getRand(List ary) {
  var aryrng = new Random();
  return ary[aryrng.nextInt(ary.length)];
}

// Parses command-line arguments
void parseArgs(List args) {

}

// Error abstraction
void argError(String err_text) {
  throw new ArgumentError("Argument error: $err_text");
}

//
// Define Character class
//

class Character {

  String cb;
  String word;

  Character() {
    String typ = getRand(["angel","demon"]);
    cb = getRand(types[typ]["cb"]);
    word = getRand(types[typ]["words"]);
  }

// If prt is True, print the output before returning it
  String output([bool prt]) {
    String out = "";
    out += "${cb} of ${word}";
    if (prt) { print(out); }
    return out;
  }

}

//
// Main function
// It accepts a list of strings as arguments,
// which are space-separated on the command line
//

void main(List<String> args) {
  parseArgs(args);
  var chr = new Character();
  chr.output(true);
}

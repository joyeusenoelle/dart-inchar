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

String lb = "\n";
String tb = "\t";

List realmlist = ["Corporeal", "Ethereal", "Celestial"];

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
  Map forces = {"Corporeal": 1, "Ethereal": 1, "Celestial": 1};
  Map attributes = {"Corporeal": [1,1], "Ethereal": [1,1], "Celestial": [1,1]};
  Map skills = {};
  List attunements = [];
  num cp = 36;
  num fcs = 6;

  Character() {
    String typ = getRand(["angel","demon"]);
    cb = getRand(types[typ]["cb"]);
    word = getRand(types[typ]["words"]);
    var i = 0;
    while (i < fcs) {
      i += addForce() ? 1 : 0;
    }
    realmlist.forEach( (el) {
      for (var j = 0; j < (forces[el] * 4) - 2; j++) {
        addChar(el);
      }
    });
  }

  bool addForce([String realm]) {
    String realm;
    if (!realm) {
      realm = getRand(realmlist);
    }
    if (forces[realm] == 6) {
      return false;
    } else {
      forces[realm] += 1;
      return true;
    }
  }

  void addChar(String realm) {
    var rnd = new Random();
    num wc = rnd.nextInt(2);
    if (attributes[realm][wc] == 12) {
      attributes[realm][1-wc] += 1;
    } else {
      attributes[realm][wc] += 1;
    }
  }

// If prt is True, print the output before returning it
  String output([bool prt]) {
    String out = "";
    out += "$cb of $word";
    out += "$lb${forces['Corporeal']} Corporeal$tb${forces['Ethereal']} Ethereal$tb${forces['Celestial']} Celestial";
    out += "$lb${attributes['Corporeal'][0]} Strength$tb${attributes['Ethereal'][0]} Intellect$tb${attributes['Celestial'][0]} Will";
    out += "$lb${attributes['Corporeal'][1]} Agility$tb${attributes['Ethereal'][1]} Precision$tb${attributes['Celestial'][1]} Perception";
    out += "$lb${lb}Skills: ";
    List skls = skills.keys;
    List sklslist = [];
    skls.forEach( (el) => sklslist.add("$el/${skills[el]}") );
    sklslist.sort();
    out += sklslist.join(", ");
    out += "${lb}Attunements: " + attunements.join(", ");
    out += "$lb$lb$cp character points remaining";
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

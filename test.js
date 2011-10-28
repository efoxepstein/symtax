(function(x){
  
  this.competition = "Vampire Hackathon";

  x.technology = function(){
    return "Ruby (1.9.2, hand-patched SCRuby, RKelly, FSSM), SuperCollider 3";
  }
  
  var we    = { win : function(){return true;} },
      our   = { names: ["Eli", "Paul", "and", "Mike"],
                happiness: 5.0
              };
  
  if( we.win(this.competition) ){
    our.happiness += 10;
  }
  
})({thank: "you"});
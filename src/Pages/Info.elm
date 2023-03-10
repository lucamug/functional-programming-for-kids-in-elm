module Pages.Info exposing (view)

import Element exposing (..)
import MarkdownElmUi
import Route
import Shared


view : Element msg
view =
    Shared.pageSkeleton
        { listParagraph = []
        , maybeSecondaryTitle = Nothing
        , notification = []
        , route = Route.RouteInfo
        , theRest = [ el [ moveUp 100, width (maximum 700 <| fill), centerX ] <| MarkdownElmUi.stringToElement content ]
        }


content : String
content =
    """

# Resources




## Podcast: Teaching Elm To 4th Graders: Christopher Anand

Most people consider ML-based langauges like Elm hard enough to learn as an adult. But according to Professor Christopher Anand of McMaster University, they work really well to introduce Computer Science to children, starting in 4th grade! In this episode, Christopher and I explore the difference between alegbraic thinking and computational (or sequential) thinking, and why this is incredibly relevant today as the “coding for all” movement gains traction.

* [https://futureofcoding.org/episodes/013.html](https://futureofcoding.org/episodes/013.html)

## ElmBridge

Workshops and curricula aimed at opening the Elm and functional language communities to the underrepresented.

* [https://github.com/elmbridge](https://github.com/elmbridge)
* [https://elmbridge.github.io/curriculum/](https://elmbridge.github.io/curriculum/)


## Book "Creating with Code" 

An Introduction to Functional Programming, User Interaction, and Design Thinking.
    
* [http://hdl.handle.net/11375/28334](http://hdl.handle.net/11375/28334)

![Creating with Code](images/creating-with-code.png "Creating with Code")

## Teacher training

A practical teacher training (grade 4~8) for teachers wanting to adopt graphics in Elm to reinforce math concepts:

* [https://stablfoundation.org/TeacherTrainingGrades4-8_2023.pdf](https://stablfoundation.org/TeacherTrainingGrades4-8_2023.pdf)

## Programação para iniciantes

* [https://elm.dev.br/](https://elm.dev.br/)


## Video: McMaster Start Coding Elm Creations - Elementary to 1XD3

* [https://www.youtube.com/watch?v=1MJ5bpKYe40](https://www.youtube.com/watch?v=1MJ5bpKYe40)


## Paper: Using Elm to Introduce Algebraic Thinking to K-8 Students

* [https://www.cs.kent.ac.uk/people/staff/sjt/TFPIE2017/TFPIE_2017/Papers/TFPIE_2017_paper_2.pdf](https://www.cs.kent.ac.uk/people/staff/sjt/TFPIE2017/TFPIE_2017/Papers/TFPIE_2017_paper_2.pdf)


## Game framework: Elm-card-game - Create Card Games in Elm

* [https://discourse.elm-lang.org/t/elm-card-game-create-card-games-in-elm/8968](https://discourse.elm-lang.org/t/elm-card-game-create-card-games-in-elm/8968)
* Example of a card game written with this framework: [https://orasund.itch.io/enough-for-now](https://orasund.itch.io/enough-for-now)








# Resources non-Elm related

* [https://www.hedycode.com/](https://www.hedycode.com/)
    





# Elm editors online

* [http://elm-editor.com/](http://elm-editor.com/)
* [https://ellie-app.com/new](https://ellie-app.com/new)
* [https://elm-lang.org/try](https://elm-lang.org/try)
* [https://guide.elm-lang.org/core_language.html](https://guide.elm-lang.org/core_language.html) with limited REPL interaction








# Other Resources

* [McMaster CAS Outreach · GitHub](https://github.com/MacCASOutreach)
* [eBook/ThinkingAlgebraicallyWithElm.pdf at master · MacCASOutreach/eBook](https://github.com/MacCASOutreach/eBook/blob/master/ThinkingAlgebraicallyWithElm.pdf)
* [graphicsvg 7.2.0](https://elm.dmy.fr/packages/MacCASOutreach/graphicsvg/latest/)
* [Terrific Coding Books to Introduce Programming to Kids | Brightly](https://www.readbrightly.com/childrens-books-to-introduce-coding/)
* [McMaster Start Coding](http://outreach.mcmaster.ca/)
* [McMaster Start Coding (@MacCSOutreach) / Twitter](https://twitter.com/MrsDavisFTPS/status/1602720237392171009/photo/3)
* [Shape Creator](http://www.cas.mcmaster.ca/~anand/SC3.html)
* [Chris Smith: CodeWorld: Teaching Haskell to kids - YouTube](https://www.youtube.com/watch?v=5ekQezLmc7Q)
* [Kids Learning Programming: Getting Started - YouTube](https://www.youtube.com/watch?v=ebTprjb-N_0&list=PLfivnkeClw0_n6DOsbfpOzz1AT81wzjYV&index=6)
* [Collision Detection in Scratch Using Pythagoras Theorem - YouTube](https://www.youtube.com/watch?v=yqnoIMaIaIg&t=136s)
* [The End of Programming | January 2023 | Communications of the ACM](https://cacm.acm.org/magazines/2023/1/267976-the-end-of-programming/fulltext)
* [Shuffle combo tutorial - cutting shapes tutorial - YouTube](https://www.youtube.com/shorts/d6hsyNyHsr4)
* [Hedy - Textual programming made easy](https://hedycode.com/)
* [Graph Bang](https://lowderdev.github.io/)
* [Looking for simple yet practical examples of using monads in Elm - Learn - Elm Discourse](https://discourse.elm-lang.org/t/looking-for-simple-yet-practical-examples-of-using-monads-in-elm/1470/8)
* [Ellie - How TEA works](https://ellie-app.com/ddKrnjXTVJMa1)
* [Etch - functional visual programing in your browser](https://letset.ch/)
* [Functional programming is finally going mainstream](https://github.com/readme/featured/functional-programming)
* [Hedy](https://www.hedycode.com/hedy)
* [Introdução - elm dev br](https://elm.dev.br/)
* [ElmBridge](https://github.com/elmbridge)
* [Introduction · GitBook](https://elmbridge.github.io/curriculum/)
* [Making a Verlet Physics Engine in JavaScript | by Anurag Hazra | Better Programming](https://betterprogramming.pub/making-a-verlet-physics-engine-in-javascript-1dff066d7bc5)
* [orthogonal graph drawing - Google Search](https://www.google.com/search?hl=en&sxsrf=AJOqlzXFeoihz6VTLYkqtpMNtsnaBqzN1w:1677320485297&q=orthogonal+graph+drawing&tbm=isch&sa=X&ved=2ahUKEwjTwczdubD9AhXY1GEKHT8JAsYQ0pQJegQIDBAB&biw=1309&bih=723&dpr=2.2)
* [Ten Minute Physics - YouTube](https://www.youtube.com/@TenMinutePhysics/videos)
* [WebGL Fluid Simulation](https://paveldogreat.github.io/WebGL-Fluid-Simulation/)
* [Coding Math: Episode 36 - Verlet Integration Part I - YouTube](https://www.youtube.com/watch?v=3HjO_RGIjCU&t=477s)
* [Artificial Particle Life - Simulation &amp; Code - YouTube](https://www.youtube.com/watch?v=0Kx4Y9TVMGg&t=695s)
* [Endosymbiosis: Lynn Margulis - Understanding Evolution](https://evolution.berkeley.edu/the-history-of-evolutionary-thought/1900-to-present/endosymbiosis-lynn-margulis/)
* [Clusters](https://www.ventrella.com/Clusters/)
* [Jeffrey Ventrella](https://www.ventrella.com/)
* [Leap Motion Particles - YouTube](https://www.youtube.com/watch?v=2GNmNjME2vg)
* [playground-elm/elm.json at master · ccamel/playground-elm](https://ccamel.github.io/playground-elm/)
* [ccamel (Chris)](https://github.com/ccamel)
* [anuraghazra.dev/Verly.js/examples](https://anuraghazra.dev/Verly.js/examples/#./typography/index.html)
* [Verly.js | Easy to use verlet physics engine](https://anuraghazra.dev/Verly.js/#./examples/ship/index.html)
* [Verlet Simulations](http://datagenetics.com/blog/july22018/index.html)
* [johnBuffer/VerletSFML](https://github.com/johnBuffer/VerletSFML)
* [Writing a Physics Engine from scratch - YouTube](https://www.youtube.com/watch?v=lS_qeBy3aQI)
* [05 - The simplest possible physics simulation method - YouTube](https://www.youtube.com/watch?v=qISgdDhdCro)
* [Physics simulation - forming solids, liquids and gases from particles - YouTube](https://www.youtube.com/watch?v=SFf3pcE08NM) 
* [https://nuplot.netlify.app/](https://nuplot.netlify.app/)

"""

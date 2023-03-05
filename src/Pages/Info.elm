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





# Resources non-Elm related

* [https://www.hedycode.com/](https://www.hedycode.com/)
    

"""

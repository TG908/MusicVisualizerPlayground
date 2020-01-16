//#-hidden-code
import PlaygroundSupport
import UIKit
import SpriteKit
import Foundation

let audioPlayer = LiveBarViewController()
let page = PlaygroundPage.current
//#-end-hidden-code
/*:
Configure your own music visualizer! You can chose the number of bars, the width and color of the bars and the spacing between the bars. The music visualizer uses the [fft](glossary://fft) to transform the spectrum of the music playing from the time domain *(right image)* to the frequency domain *(left image)*. Each bar represents a certain [frequency](glossary://frequency) range. The bars height represents the [magnitude](glossary://magnitude) of the frequency range.\
The frequency increases from left to right.
 ![func](func.png)
 */

//Choose a song
audioPlayer.audioURL = /*#-editable-code*/#fileLiteral(resourceName: "DEAF KEV - Invincible.m4a")/*#-end-editable-code*/
//#-hidden-code
page.liveView = audioPlayer
//#-end-hidden-code

//Create the bar visualizer
audioPlayer.createBars(numberOfBars: /*#-editable-code*/<#T##number of bars##Int#>/*#-end-editable-code*/, width: /*#-editable-code*/<#T##width of the bars##CGFloat#>/*#-end-editable-code*/, spacing: /*#-editable-code*/<#T##space between the bars##CGFloat#>/*#-end-editable-code*/, color: /*#-editable-code*/#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)/*#-end-editable-code*/)

/*:
 Music:\
[My Heart](https://soundcloud.com/different-heaven/my-heart) by Different Heaven & EH!DE is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/)\
[Fade](https://soundcloud.com/alanwalker/alan-walker-fade) by Alan Walker is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).\
[Spectre](https://soundcloud.com/alanwalker/alan-walker-spectre) by Alan Walker is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).\
[Invincible](https://soundcloud.com/atm-dubstep/invincible-out-now-on-nocopyrightsounds) by DEAF KEV is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).
 */

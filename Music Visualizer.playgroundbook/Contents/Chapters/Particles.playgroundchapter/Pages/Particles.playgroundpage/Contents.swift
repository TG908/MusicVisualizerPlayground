//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation
import SpriteKit

let audioPlayer = LiveParticleViewController()
let page = PlaygroundPage.current

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, music, fire, spark)
//#-code-completion(identifier, show, FrequencyType)
//#-code-completion(keyword, show, let, var)

//#-code-completion(identifier, hide, leftSoundProducer(), rightSoundProducer(), SoundProducer, viewController, storyBoard, SoundBoard, MusicViewController, Instrument, ClampedInteger, AudioPlayerEngine, connect(_:))

//#-end-hidden-code
/*:
 The particle visualizer only displays the loudest, quietest or average frequency and magnitude unlike, the bar visualizer which represents the whole spectrum. The movement of the particlie on the x-axis represents the current frequency. The y-axis represents the magnitude of the current frequency.
 */

//Choose a song
audioPlayer.audioURL = /*#-editable-code*/#fileLiteral(resourceName: "DEAF KEV - Invincible.m4a")/*#-end-editable-code*/
//#-hidden-code
page.liveView = audioPlayer
//#-end-hidden-code

//#-end-editable-code
/*:
 Use a pre-built particle from a file
 (You can choose from 3 different particle system: ice, fire, spark). On the next page you can create your own custom particle.
 */
let ice = SKEmitterNode(fileNamed: "ice.sks")!
    ice.name = "createdFromFile"
let fire = SKEmitterNode(fileNamed: "fire.sks")!
    fire.name = "createdFromFile"
let spark = SKEmitterNode(fileNamed: "spark.sks")!
    spark.name = "createdFromFile"

/*:
 Add your particles to the scene, select a source for the audio and define how it reacts to the audio. FrequencySource defines the source of the audio (leftChannel or rightChannel). FrequencyType defines how the audio data is processed (quietestFrequency, loudestFrequency or averageFrequency)
 */
//#-code-completion(everything, show)
audioPlayer.addParticleSystem(forSource: /*#-editable-code*/<#T##audio source##FrequencySource#>/*#-end-editable-code*/, withType: /*#-editable-code*/<#T##audio type##FrequencyType#>/*#-end-editable-code*/, particle: /*#-editable-code*/<#T##particle##SKEmitterNode#>/*#-end-editable-code*/)
//#-editable-code Add additional particles...
//#-end-editable-code

/*:
 Music:\
[My Heart](https://soundcloud.com/different-heaven/my-heart) by Different Heaven & EH!DE is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/)\
[Fade](https://soundcloud.com/alanwalker/alan-walker-fade) by Alan Walker is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).\
[Spectre](https://soundcloud.com/alanwalker/alan-walker-spectre) by Alan Walker is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).\
[Invincible](https://soundcloud.com/atm-dubstep/invincible-out-now-on-nocopyrightsounds) by DEAF KEV is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).
 */

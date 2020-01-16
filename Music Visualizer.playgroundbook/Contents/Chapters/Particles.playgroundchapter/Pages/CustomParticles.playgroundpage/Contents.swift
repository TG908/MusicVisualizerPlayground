//#-hidden-code
import PlaygroundSupport
import UIKit
import Foundation
import SpriteKit

let audioPlayer = LiveParticleViewController()
let page = PlaygroundPage.current


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
 Create your own custom particle, the custom particle template contains example values from the ice particle used on the prevoius page
 */
//#-hidden-code
let texture = UIImage(named:"circle.png")!
//#-end-hidden-code

let myParticle = SKEmitterNode()
//#-hidden-code
myParticle.particleTexture = SKTexture(image: texture)
//#-end-hidden-code

myParticle.particleBirthRate = /*#-editable-code*/400/*#-end-editable-code*/
myParticle.particleLifetime = /*#-editable-code*/1/*#-end-editable-code*/
myParticle.particleLifetimeRange = /*#-editable-code*/0/*#-end-editable-code*/
myParticle.particlePositionRange = CGVector(dx: /*#-editable-code*/0/*#-end-editable-code*/, dy: /*#-editable-code*/0/*#-end-editable-code*/)
myParticle.emissionAngle = /*#-editable-code*/89.954/*#-end-editable-code*/
myParticle.emissionAngleRange = /*#-editable-code*/360.39/*#-end-editable-code*/
myParticle.speed = /*#-editable-code*/20/*#-end-editable-code*/
myParticle.particleSpeedRange = /*#-editable-code*/20/*#-end-editable-code*/
myParticle.xAcceleration = /*#-editable-code*/0/*#-end-editable-code*/
myParticle.yAcceleration = /*#-editable-code*/-50/*#-end-editable-code*/
myParticle.alpha = /*#-editable-code*/1/*#-end-editable-code*/
myParticle.particleAlphaRange = /*#-editable-code*/0.2/*#-end-editable-code*/
myParticle.particleAlphaSpeed = /*#-editable-code*/-1/*#-end-editable-code*/
myParticle.particleScale = /*#-editable-code*/0.4/*#-end-editable-code*/
myParticle.particleScaleRange = /*#-editable-code*/0.2/*#-end-editable-code*/
myParticle.particleAlphaSpeed = /*#-editable-code*/-0.4/*#-end-editable-code*/
myParticle.particleRotation = /*#-editable-code*/0/*#-end-editable-code*/
myParticle.particleRotationRange = /*#-editable-code*/359.818/*#-end-editable-code*/
myParticle.particleRotationSpeed = /*#-editable-code*/0/*#-end-editable-code*/
myParticle.particleColorBlendFactor = /*#-editable-code*/1/*#-end-editable-code*/
myParticle.particleColorBlendFactorRange = /*#-editable-code*/0/*#-end-editable-code*/
myParticle.particleColorBlendFactorSpeed = /*#-editable-code*/0/*#-end-editable-code*/
myParticle.particleBlendMode = /*#-editable-code*/.add/*#-end-editable-code*/

//Create a custom color sequence
let colorSequence = SKKeyframeSequence(keyframeValues: /*#-editable-code*/[#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.9216244115, blue: 0.1583373313, alpha: 1),#colorLiteral(red: 1, green: 0, blue: 0.02780562414, alpha: 1),#colorLiteral(red: 0.2391340866, green: 0.3441876607, blue: 1, alpha: 1)]/*#-end-editable-code*/, times:/*#-editable-code*/[0, 0.25, 0.5, 1]/*#-end-editable-code*/)
colorSequence.interpolationMode = /*#-editable-code*/.linear/*#-end-editable-code*/

myParticle.particleColorSequence = colorSequence

//#-editable-code Crreate additional particles...
//#-end-editable-code

/*:
 Add your particles to the scene, select a source for the audio and define how it reacts to the audio. FrequencySource defines the source of the audio (leftChannel or rightChannel). FrequencyType defines how the audio data is processed (quietestFrequency, loudestFrequency or averageFrequency)
 */
audioPlayer.addParticleSystem(forSource: /*#-editable-code*/.leftChannel/*#-end-editable-code*/, withType: /*#-editable-code*/.loudestFrequency/*#-end-editable-code*/, particle: /*#-editable-code*/myParticle/*#-end-editable-code*/)
//#-editable-code Add your additional particles to the scene...
//#-end-editable-code
/*:
 Music:\
[My Heart](https://soundcloud.com/different-heaven/my-heart) by Different Heaven & EH!DE is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/)\
[Fade](https://soundcloud.com/alanwalker/alan-walker-fade) by Alan Walker is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).\
[Spectre](https://soundcloud.com/alanwalker/alan-walker-spectre) by Alan Walker is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).\
[Invincible](https://soundcloud.com/atm-dubstep/invincible-out-now-on-nocopyrightsounds) by DEAF KEV is licensed under a [Creative Commons License](https://creativecommons.org/licenses/by-sa/3.0/).
 */

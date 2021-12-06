import SwiftUI
/*:
 # Async let – Constante asynchrone
 * ⚠️ Xcode 13.1 : erreurs de compilation dans le playground mais fonctionne très bien dans un réel projet ⚠️
 */
/*:
 * Avant de savoir comment utiliser `async let`, il est plus important de savoir **quand l'utiliser**
 * Créons une fonction asynchrone (marquée `async`) pour fetch une image
 * Dans cette fonction on print l'index de l'image lorsque le fetch est fini
 */
func loadImage(index: Int) async -> UIImage {
  let imageURL = URL(string: "https://picsum.photos/200/300")!
  let request = URLRequest(url: imageURL)
  let (data, _) = try! await URLSession.shared.data(for: request)
  print("image\(index) – Finished loading")
  return UIImage(data: data)!
}
//: * Disons que nous voulons fetcher 3 images aléatoires, notre code ressemblerait à ceci sans l'utilisation de `async let`
func loadImages() async {
  let firstImage = await loadImage(index: 1)
  let secondImage = await loadImage(index: 2)
  let thirdImage = await loadImage(index: 3)
  let imagesFetched = [firstImage, secondImage, thirdImage]
  
  print("images contained \(imagesFetched.count) images")
}

Task {
  await loadImages()
}
/*:
 * Dans l'exemple ci-dessus notre code (et les print) indiquent qu'on attend que la 1ère image soit récupérée avant de pouvoir déclencher le fetch de la seconde et ainsi de suite
 * **Toutes les images sont chargées de manière séquentielle**
 * De ce fait l'ordre sera toujours le même dans la console : *image1*, puis *image2* puis *image3*
 * À première vue, cela semble ok : nos images sont chargées de manière asynchrones et on obtient notre tableau de `UIImage`
 */
/*:
 * Cependant il serait **beaucoup plus optimal de charger les images en parallèles, *en concurrence*** et de profiter des ressources systèmes disponibles au lieu d'attendre les fetch un à un
 * `async let` résout cette problématique et **permet de fetcher des datas en paralèlle**, de *manière concurrentielle*
 * **C'est un excellent mécanisme pour télécharger des datas en parallèle tout en combinant les résultats, une fois que toutes les requêtes asynchrones sont finies**
 */
/*:
 * *Behind the scenes*, lorsqu'on déclare un `async let`, Swift créer une child `Task` sur un autre thread qui hérite de la priorité de sa tâche parent
 * Un `async let` correspond plus au moins à un `DispatchGroup` dans GCD ou un `zip` en Combine
 */
/*:
 * Modifions la fonction précèdente afin de profiter de cela :
    * Ajout de `async` devant les `let`
    * Suppresions des `await` avant l'appel à `loadImage(index:)`
    * Ajout de `await` avant l'assignation du tableau d'images à `imagesFetched`
 */
func loadImagesInParallel() async {
  async let firstImage = loadImage(index: 1)
  async let secondImage = loadImage(index: 2)
  async let thirdImage = loadImage(index: 3)
  let imagesFetched = await [firstImage, secondImage, thirdImage]
  
  print("images contained \(imagesFetched.count) images")
}

Task {
  await loadImagesInParallel()
}
/*:
 * Quelques éléments à souligner :
    * Lorsqu'on assigne le tableau, celui-ci doit être **précédé de `await` car nous utilisons des constantes asynchrones, définit par `async let`**
    * **Le déclenchement d'un fetch se fait dès que nous définissions un `async let`**
 */
/*:
 * Le dernier point signifie que l'une des images pourrait déjà être téléchargée avant même d'avoir été `await` par notre tableau
 * Cependant cela n'est que théorique, car il est beaucoup plus probable que notre code s'exécute plus vite que le téléchargement d'une data (ici une image)
 * Ainsi à l'exécution, la fonction peut (potentiellement) afficher un output différent à chaque fois
 */
//: * Il faut assigner les résultats en utilisant `await` si les **lignes suivantes dépendent du résultat de la / des méthode(s) `async`**
/*:
 * `async let` avec des fonctions `async throws` :
    * Lors de l'assignation de plusieurs `async let`, si au moins l'une des fonction `async throws`, alors il faut faire **précédé l'assignation par `try await`**
    * De plus cette assignation doit se faire dans un `do` `catch` block
 * Définissons la même fonction pour fetch une image mais qui `throws`, que nous utiliserons uniquement pour la dernière image
 */
func loadImageThrowing(index: Int) async throws -> UIImage {
  let imageURL = URL(string: "https://picsum.photos/200/300")!
  let request = URLRequest(url: imageURL)
  let (data, _) = try await URLSession.shared.data(for: request)
  print("throwing image\(index) – Finished loading")
  return UIImage(data: data)!
}

func loadImagesInParallelWithOneThrowingFunction() async {
  async let firstImage = loadImage(index: 1)
  async let secondImage = loadImage(index: 2)
  async let thirdImageThrowing = loadImageThrowing(index: 3)
  
  do {
    let imagesFetched = try await [firstImage, secondImage, thirdImageThrowing]
    print("images contained \(imagesFetched.count) images")
  } catch {
    print("Something went wrong")
  }
}

Task {
  await loadImagesInParallelWithOneThrowingFunction()
}
/*:
 * Enfin il n'est pas possible de déclarer des `async let` comme `stored property`, cela générera deux erreurs :
    * *'async let' can only be used on local declarations*
    * *'async' call cannot occur in a property initializer*
 * En d'autres termes, les **`async let` ne peuvent être utilisés que dans des locals scope c'est à dire des functions**
 */
final class ViewModel {
  async let image = await loadImage(index: 0)
}

//
//  ContentView.swift
//  CacheBootcamp
//
//  Created by hazem smawy on 10/23/22.
//

import SwiftUI

class CacheManager {
    static let instance = CacheManager()
    private init(){ }
    
    var imageCache:NSCache<NSString,UIImage> = {
        let cache = NSCache<NSString,UIImage>()
        cache.countLimit = 10
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func add(image:UIImage, name:String) -> String{
        imageCache.setObject(image, forKey: name as NSString)
       return "Added to cache"
    }
    func remove(name:String) -> String {
        imageCache.removeObject(forKey: name as NSString)
        return "Removed from Cache!"
    }
    func get(name:String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}

class CacheViewModel:ObservableObject {
    @Published var startingImage : UIImage? = nil
    @Published var cachedImage:UIImage? = nil
    @Published var MSG:String = ""
    let imageName:String = "logo"
    let manager = CacheManager.instance
    init() {
        getImageFromAssetsFolder()
    }
    func getImageFromAssetsFolder() {
        startingImage = UIImage(named: imageName)
    }
    
    func saveToCache() {
        guard let image = startingImage else {
            return
        }
        MSG = manager.add(image: image, name: imageName)
    }
    func removeFromCache(){
        MSG = manager.remove(name: imageName)
    }
    func getFromCache(){
        cachedImage = manager.get(name: imageName)
    }
}


struct ContentView: View {
    // MARK: - Property
    @StateObject var vm = CacheViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                if let image = vm.startingImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200, alignment: .center)
                        .background(.white.opacity(0.1))
                        .clipped()
                        .cornerRadius(10)
                        .padding()
                }
               
                if let msg = vm.MSG {
                    Text(msg)
                        .foregroundColor(.white)
                        .font(.caption)
                }
                
                HStack {
                    Button {
                        vm.saveToCache()
                    } label: {
                        Text("Save to Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        vm.removeFromCache()
                    } label: {
                        Text("delete from cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.red)
                            .cornerRadius(10)
                    }
                    
                    
                }
                Divider()
                Button {
                    vm.getFromCache()
                } label: {
                    Text("get from cache")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                }
                
                
                if let image = vm.cachedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200, alignment: .center)
                        .background(.white.opacity(0.1))
                        .clipped()
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Cache Bootcamp")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

//
//  Home.swift
//  SwiftUICustomSlider
//
//  Created by ricardo silva on 23/04/2022.
//

import SwiftUI
import AudioUnit

struct Home: View {
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            Image("exercise")
                .padding(.top, 40)
            Spacer(minLength: 0)
            
            Text("Weight")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.black)
            
            
            Text("\(getWeight()) Kg")
                .font(.system(size: 38, weight: .heavy))
                .foregroundColor(Color("purple1"))
                .padding(.bottom)
            
            let pickerCount = 6
            CustomSlider(pickerCount: pickerCount, offset: $offset) {
                
                
                HStack(spacing:0) {
                    ForEach(1...pickerCount, id: \.self) { index in
                        VStack {
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 1, height: 30)
                            
                            Text("\(30 + (index * 10))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 25)
                        
                        ForEach(1...4, id: \.self) { subIndex in
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 1, height: 15)
                                .frame(width: 25)
                        }
                    }
                    VStack {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 1, height: 30)
                        
                        Text("\(100)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 25)
                }
            }
            .frame(height: 50)
            .overlay(
                Rectangle()
                    .fill(.gray)
                    .frame(width: 1, height: 50)
                    .offset(x:1, y: -30)
            )
            .padding()
            
            Button {
                
            } label: {
                Text("Next")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 60)
                    .background(Color("purple1"))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Circle()
                .fill(Color("purple"))
                .scaleEffect(1.5)
                .offset(y: -getRect().height / 2.4)
        )
    }
    
    func getWeight() -> String {
        let startWeight = 40
        
        let progress = offset / 25
        
        return "\(startWeight + (Int(progress) * 2))"
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

func getRect() -> CGRect {
    return UIScreen.main.bounds
}


struct CustomSlider<Content: View>: UIViewRepresentable {
    
    var content: Content
    
    @Binding var offset: CGFloat
    var pickerCount: Int
    
    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._offset = offset
        self.pickerCount = pickerCount
    }
    
    func makeCoordinator() -> Coordinator {
        return CustomSlider.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        let swiftUIView = UIHostingController(rootView: content).view!
        
        let width = CGFloat((pickerCount*5) * 25) + (getRect().width - 30)
        
        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        
        scrollView.contentSize = swiftUIView.frame.size
        scrollView.addSubview(swiftUIView)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: CustomSlider
        
        init(parent: CustomSlider) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            
            let value = (offset / 25).rounded(.toNearestOrAwayFromZero)
            
            scrollView.setContentOffset(CGPoint(x: value * 25, y:0), animated: false)
            
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(1157)
            
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                let offset = scrollView.contentOffset.x
                
                let value = (offset / 25).rounded(.toNearestOrAwayFromZero)
                
                scrollView.setContentOffset(CGPoint(x: value * 25, y:0), animated: false)
                
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(1157)
            }
        }
    }
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
//Generate by Gemini 2026.04.23
// 手感是要靠持续练习来维持的。波动方程在 Shader 中通常有两种实现方式：一种是基于**数学近似（波函数叠加）**，另一种是基于**数值模拟（有限差分法）**。

// 为了让你找回感觉，我们采用**数学近似法**，因为它最能体现“坐标变换”和“函数塑形”的基本功。

// ---

// ### 1. 理论基础：简谐波叠加

// 波动在数学上最简单的表达是 **正弦波（Sine Wave）**。

// * **单一波方程：**
//     $$y(d, t) = A \cdot \sin(k \cdot d - \omega \cdot t)$$
//     * $A$ (**Amplitude**)：振幅，决定波的高度。
//     * $k$ (**Wave Number**)：波数，决定波的密集程度（频率）。
//     * $d$ (**Distance**)：距离，决定波从哪里扩散（通常是到中心的距离或 $uv.x$）。
//     * $\omega$ (**Angular Frequency**)：角频率，决定波动的快慢。

// * **波的干涉（Interference）：**
//     当多个不同频率、不同方向的波相遇时，它们会产生**线性叠加**。叠加后的波纹会呈现出破碎、随机但又具有韵律感的视觉效果，这比单一的正弦波要真实得多。

// ---

// ### 2. 实现思路：从一维到二维

// 1.  **空间构建：** 首先将 `uv` 映射到以中心为原点的坐标系，这样我们可以方便地计算径向距离（Radial Distance），实现环形扩散的水波。
// 2.  **波函数构造：** * 构造一个主环形波（从中心扩散）。
//     * 叠加一个定向波（比如横向或斜向），破坏对称性，增加自然感。
// 3.  **法线估算（重点）：**
//     既然是模拟波动，我们不仅仅需要颜色，还需要**光影**。波动会导致表面倾斜，我们可以通过波动函数的导数（或差分）来模拟“伪法线”，从而结合你之前的 **Blinn-Phong** 知识。
// 4.  **色彩与光照：**
//     根据高度值 `h` 进行颜色插值，并利用法线计算高光。

// ---

// ### 3. 代码实战：进阶波动 Shader

// 这段代码在你的基础上增加了法线偏移，让水面看起来有立体感。

// ```glsl
// // 计算波动的函数，返回高度 h
// float getWaveHeight(vec2 p) {
//     float d = length(p);
    
//     // 波浪 1：径向扩散波
//     float w1 = sin(d * 15.0 - iTime * 3.0);
    
//     // 波浪 2：斜向直线波，增加破碎感
//     float w2 = sin(p.x * 12.0 + p.y * 8.0 + iTime * 2.0);
    
//     // 叠加并归一化到 0-1
//     return (w1 * 0.5 + w2 * 0.5) * 0.5 + 0.5;
// }

// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
//     // 坐标归一化
//     vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    
//     // 1. 获取当前点的波动高度
//     float h = getWaveHeight(uv);
    
//     // 2. 简易法线模拟 (通过微小的偏移求差分)
//     float e = 0.01;
//     float hx = getWaveHeight(uv + vec2(e, 0.0)) - h; // x 方向倾斜度
//     float hy = getWaveHeight(uv + vec2(0.0, e)) - h; // y 方向倾斜度
//     vec3 normal = normalize(vec3(-hx, -hy, e));    // 构造近似法线
    
//     // 3. 基础色彩与光照
//     vec3 lightDir = normalize(vec3(1.0, 1.0, 0.8));
//     vec3 viewDir = vec3(0.0, 0.0, 1.0);
//     vec3 halfwayDir = normalize(lightDir + viewDir);
    
//     // 漫反射 (基于法线)
//     float diff = max(dot(normal, lightDir), 0.0);
//     vec3 waterCol = mix(vec3(0.0, 0.1, 0.3), vec3(0.1, 0.7, 0.9), h);
    
//     // 高光 (Blinn-Phong)
//     float spec = pow(max(dot(normal, halfwayDir), 0.0), 32.0);
    
//     // 合成输出
//     vec3 finalCol = waterCol * (diff + 0.5) + spec * 0.5;
    
//     // 增加一点边缘暗角（Vignette）
//     finalCol *= smoothstep(1.0, 0.2, length(uv));

//     fragColor = vec4(finalCol, 1.0);
// }
// ```



// ---

// ### 4. 深度分析与进阶

// * **为什么用差分求法线？**
//     真正的波动方程通过高度图渲染时，由于没有真实的 3D 模型，我们需要手动计算表面的倾斜程度。`hx` 和 `hy` 实际上是在计算曲面的**梯度（Gradient）**。梯度越大，说明斜率越陡，反射的光线角度就越大。
// * **物理性能与美感的平衡：**
//     在游戏制作中，如果你需要更真实的波动（比如波浪互相碰撞并反弹），通常会使用 **FFT（快速傅里叶变换）** 或 **Gerstner Waves**。但对于小型特效，这种 `sin` 叠加法（Sinusoidal approximation）效率最高。

// **你可以尝试修改 `getWaveHeight` 里的参数，看看频率变高后，画面是否会呈现出“绸缎”般的质感？或者尝试把 `iChannel0` 引入进来，用 `hx` 和 `hy` 去偏移贴图的 UV，实现真正的“水底折射”。**

    vec2 uv =(fragCoord-0.5*iResolution.xy)/iResolution.y;
    
    fragColor=vec4(1.0, 0.0, 0.0, 1.0);

}
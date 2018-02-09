Shader "Hidden/Rgb Split"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex1 ("Noise Texture A", 2D) = "white" {}
		_NoiseTex2 ("Noise Texture B", 2D) = "white" {}
	}
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex,_NoiseTex1,_NoiseTex2;
			float3 colorSplit(float2 uv, float2 s)
{
    float3 color;
    color.r = tex2D(_MainTex, uv - s).r;
    color.g = tex2D(_MainTex, uv    ).g;
    color.b = tex2D(_MainTex, uv + s).b;
    return color;
}

float2 interlace(float2 uv, float s)
{
    uv.x += s * (4.0 * frac((uv.y) / 2.0) - 1.0);
    return uv;
}

	fixed4 frag (v2f i) : SV_Target
	{

	float t = _Time.y;
    
    float s = tex2D(_NoiseTex1, float2(t * 0.2, 0.5)).r;
    
    i.uv = interlace(i.uv, s * 0.005);
    float r = tex2D(_NoiseTex2, float2(t, 0.0)).x;

    float3 color = colorSplit(i.uv, float2(s * 0.02, 0.0));
    
	return float4(color, 1.0);

			}
			ENDCG
		}
	}
}

Shader "Custom/GrabPassInvertColors"
{
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_Intensity("Intensity",Float) = 0
        _Alpha("Alpha",Float) = 1
	}
    SubShader
    {
Tags {"Queue"="Transparent" "RenderType"="Transparent"}
 Blend SrcAlpha OneMinusSrcAlpha 

 
        GrabPass
        {
            "_GrabTexture"
        }
 
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
				float3 normal :NORMAL;
            };
 
            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				half3 worldNormal :TEXCOORD1;

            };
			sampler2D _MainTex;
			float _Intensity,_Alpha;
 
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeGrabScreenPos(o.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }
 
            sampler2D _GrabTexture;
 
            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 c = 0;
				c.rgb = i.worldNormal*0.5+0.5;
				float4 distortion = tex2D(_MainTex,i.uv)+_Intensity;
                fixed4 col = tex2Dproj(_GrabTexture, i.uv+c.r);
                i.uv.r += 5;
                return float4(col.rgb,_Alpha);
            }
            ENDCG
        }
    }
}
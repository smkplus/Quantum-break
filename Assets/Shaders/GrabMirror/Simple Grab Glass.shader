Shader "Smkgames/GlassRefraction"
{
	Properties{
        _Refraction("Refraction",Float) = 0.05
        _Alpha("Alpha",Range(0,1)) = 1
	}
    SubShader
    {
Tags {"Queue"="Transparent" "RenderType"="Transparent"}

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
            };
 
            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
			sampler2D _MainTex;
			float _Alpha,_Refraction;
 
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeGrabScreenPos(o.vertex);
                return o;
            }
 
            sampler2D _GrabTexture;
 
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2Dproj(_GrabTexture, i.uv+_Refraction);
                return float4(col.rgb,_Alpha);

            }
            ENDCG
        }
    }
}